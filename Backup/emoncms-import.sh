#!/bin/bash

date=$(date +"%Y-%m-%d")
SECONDS=0
config_file="/opt/emoncms/modules/backup/config.cfg"
log="/var/log/emoncms/importbackup.log"
nodered_path="/home/pi/.node-red"

echo "========================= Emoncms import start =========================================="
date
echo "This import script has been modified by jatg"
echo ""
if [ -f $config_file ]
then
    source $config_file
    echo "Log file: $log"
    backup_source_path=$backup_source_path
    echo "-----------------------------------------------------------------------------------------"
    echo "File config.cfg: "
    echo "Location of emonhub.conf:   $emonhub_config_path"
    echo "Location of Emoncms:        $emoncms_location"
    echo "Location of Node Red:       $nodered_path"
    echo "Backup source:              $backup_source_path"
    echo "-----------------------------------------------------------------------------------------"
else
    echo "ERROR: Backup $config_file file does not exist"
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
if [ -f $backup_script_location/get_emoncms_mysql_auth.php ]; then
    auth=$(echo $emoncms_location | php $backup_script_location/get_emoncms_mysql_auth.php php)
    IFS=":" read username password database<<< "$auth"
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
#pv -fptb -s$(du -sb $backup_source_path/$backup_filename | awk '{print $1}') $backup_source_path/$backup_filename | tar xz -C $backup_location/import
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
        echo "- Stopping emoncms_mqtt service"
        sudo service emoncms_mqtt stop
        echo "- Stopping nodered service"
        sudo service nodered stop
        echo "- Importing Emoncms MYSQL database"
        mysql -u$username -p$password $database < $backup_location/import/emoncms.sql
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
echo "- Importing feeds meta data"
sudo rm -rf $database_path/{phpfina,phptimeseries} 2> /dev/null
#echo "- Restore phpfina and phptimeseries data folders..."
if [ -d $backup_location/import/phpfina ]; then
	sudo mv $backup_location/import/phpfina $database_path
	sudo chown -R www-data:root $database_path/phpfina
fi
if [ -d  $backup_location/import/phptimeseries ]; then
	sudo mv $backup_location/import/phptimeseries $database_path
	sudo chown -R www-data:root $database_path/phptimeseries
fi
# cleanup
sudo rm $backup_location/import/emoncms.sql
# Save previous config settings as old.emonhub.conf and old.emoncms.conf
sudo cp  $emonhub_config_path/emonhub.conf $emonhub_config_path/old.emonhub.conf
echo "- Importing emonhub.conf"
sudo mv $backup_location/import/emonhub.conf $emonhub_config_path/emonhub.conf
sudo touch $emonhub_config_path/emonhub.conf
sudo chown pi:www-data $emonhub_config_path/emonhub.conf
sudo chmod 664 $emonhub_config_path/emonhub.conf
echo "- Importing nodered flows"
sudo mv $backup_location/import/nodered/flows_raspberrypi.json $nodered_path/flows_raspberrypi.json
#mv $backup_location/import/nodered/flows_raspberrypi_cred.json $nodered_path/flows_raspberrypi_cred.json
echo "- Restarting emoncms_input service"
sudo service emoncms_mqtt start
echo "- Restarting nodered service"
sudo service nodered start
redis-cli "flushall" 1>/dev/null
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

