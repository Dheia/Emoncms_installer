#!/bin/bash
log="/home/pi/data/emoncms-import.log"
backup_source_path="/home/pi/data/uploads"
data_path="/home/pi/data"
date=$(date +"%Y-%m-%d")
SECONDS=0

echo "========================= Emoncms import start =========================================="
date
echo "This import script has been modified by jatg"
echo ""
if [ -f /home/pi/backup/config.cfg ]
then
    source /home/pi/backup/config.cfg
    echo "-----------------------------------------------------------------------------------------"
    echo "File config.cfg: "
    echo "Location of database:       $mysql_path"
    echo "Location of emonhub.conf:   $emonhub_config_path"
    echo "Location of Emoncms:        $emoncms_location"
    echo "Location of Node Red:       $nodered_path"
    echo "Backup source:              $backup_source_path"
    echo "-----------------------------------------------------------------------------------------"
else
    echo "ERROR: Backup /home/pi/backup/config.cfg file does not exist"
    exit 1
fi

echo "- Starting import from $backup_source_path to $backup_location"

# Get latest backup filename
if [ ! -d $backup_source_path ]; then
	echo "Error: $backup_source_path does not exist, nothing to import"
	exit 1
fi

backup_filename=$((cd $backup_source_path && ls -t *.tar.gz) | head -1)
if [[ -z "$backup_filename" ]] #if backup does not exist (empty filename string)
then
    echo "Error: cannot find backup, stopping import"
    exit 1
fi
# if backup exists
echo "- Importing backup file: $backup_filename"
if [ -f /home/pi/backup/get_emoncms_mysql_auth.php ]; then
    auth=$(echo $emoncms_location | php /home/pi/backup/get_emoncms_mysql_auth.php php)
    IFS=":" read username password <<< "$auth"
else
    echo "Error: cannot read MYSQL authentication details from Emoncms settings.php"
    echo "$PWD"
    exit 1
fi
if [ ! -d  $backup_location/import ]; then
	mkdir $backup_location/import
	sudo chown pi $backup_location/import -R
fi
echo "- Decompressing $backup_filename"
pv -fptb -s $(du -sb $backup_source_path/$backup_filename | awk '{print $1}') $backup_source_path/$backup_filename 2> >( while read -N 1 c; do if [[ $c =~ $'\r' ]]; then sed -i "$ s/.*/   $pv_bar/g" $log; pv_bar=''; else pv_bar+="$c";  fi  done ) |\
tar xz -C $backup_location/import
sleep 1;
exec 1>>$log
if [ $? -ne 0 ]; then
	echo "Error: failed to decompress backup"
	echo "$backup_source_path/$backup_filename has not been removed for diagnotics"
	echo "Removing files in $backup_location/import"
	sudo rm -Rf $backup_location/import/*
	echo "Import failed"
	exit 1
fi
echo "- Removing compressed backup to save disk space"
sudo rm $backup_source_path/$backup_filename
if [ -n "$password" ]
then # if username sring is not empty
    if [ -f $backup_location/import/emoncms.sql ]; then
        echo "- Stopping mqtt_input service"
        sudo service mqtt_input stop
        echo "- Stopping nodered service"
        sudo service nodered stop
        echo "- Importing Emoncms MYSQL database"
        mysql -u$username -p$password emoncms < $backup_location/import/emoncms.sql
	if [ $? -ne 0 ]; then
		echo "Error: failed to import mysql data"
		echo "Import failed"
		exit 1
	fi
    else
        "Error: cannot find emoncms.sql database to import"
        exit 1
    fi
else
    echo "Error: cannot read MYSQL authentication details from Emoncms settings.php"
    exit 1
fi
echo "Import feed meta data"
sudo rm -rf $mysql_path/{phpfina,phptimeseries} 2> /dev/null
echo "Restore phpfina and phptimeseries data folders..."
if [ -d $backup_location/import/phpfina ]; then
	sudo mv $backup_location/import/phpfina $mysql_path
	sudo chown -R www-data:root $mysql_path/phpfina
fi
if [ -d  $backup_location/import/phptimeseries ]; then
	sudo mv $backup_location/import/phptimeseries $mysql_path
	sudo chown -R www-data:root $mysql_path/phptimeseries
fi
# cleanup
sudo rm $backup_location/import/emoncms.sql
# Save previous config settings as old.emonhub.conf and old.emoncms.conf
cp  $emonhub_config_path/emonhub.conf $emonhub_config_path/old.emonhub.conf
echo "- Import emonhub.conf > $emonhub_config_path/emohub.conf"
mv $backup_location/import/emonhub.conf $emonhub_config_path/emonhub.conf
sudo touch $emonhub_config_path/emonhub.conf
sudo chown pi:www-data $emonhub_config_path/emonhub.conf
sudo chmod 664 $emonhub_config_path/emonhub.conf
redis-cli "flushall" 2>&1
if [ -f /home/pi/emonpi/emoncmsdbupdate.php ]; then
    echo "Updating Emoncms Database.."
    php /home/pi/emonpi/emoncmsdbupdate.php ##AQUIIIIIIIIIIIIIIIIIII
fi
echo "- Restarting mqtt_input service"
sudo service mqtt_input start
echo "- Restarting nodered service"
sudo service nodered start
duration=$SECONDS
echo "" 
echo "=========================================================================================" 
echo "    $(date)"  
echo "    Import time: $(($duration / 60)) min $(($duration % 60)) sec"
echo "    Backup imported: $backup_filename"  
echo "    Import finished...refresh page to view download link"
echo "=========================================================================================" 
echo " "
echo "=== Emoncms import complete! ===" 
# The last line is identified in the interface to stop ongoing AJAX calls, please ammend in interface if changed here
sudo service apache2 restart
