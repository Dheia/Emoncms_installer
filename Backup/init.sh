#backup_script_location="/opt/emoncms/modules/backup"
#backup_location="/opt/openenergymonitor/data"
if [ -f /opt/emoncms/modules/backup/config.cfg ]

#Replace import,export script with mod version
cd $backup_script_location
[ -f "emoncmcs-export.sh" ] && rm emoncmcs-export.sh
[ -f "emoncmcs-import.sh" ] && rm emoncmcs-import.sh
cp $openenergymonitor_dir/Emoncms-Scripts/Backup/emoncmcs-export.sh $backup_script_location
cp $openenergymonitor_dir/Emoncms-Scripts/Backup/emoncmcs-import.sh $backup_script_location

# Set Fstab file to mount NAS folder Backup_EmonPi
var="//192.168.0.11/Backup_EmonPi  /media/Emoncms_backup_diario cifs username=emonpi,password=pi 0 0"
[ $(grep -c "$var" /etc/fstab) -eq 0 ] && echo -e "\n$var" | sudo tee -a /etc/fstab
sudo mount -a

#Cron settings export backup automatically at 4:00
(crontab -l ; echo "00 4 * * * $backup_script_location/emoncms-export.sh >> $backup_location/emoncms-export.log 2>&1" ) | crontab -
#df -h
