cd $emoncms/modules/backup
[ -f "emoncmcs-export.sh" ] && rm emoncmcs-export.sh
[ -f "emoncmcs-import.sh" ] && rm emoncmcs-import.sh

cp $openenergymonitor_dir/Emoncms-Scripts/Backup/emoncmcs-export.sh $emoncms/modules/backup
cp $openenergymonitor_dir/Emoncms-Scripts/Backup/emoncmcs-import.sh $emoncms/modules/backup

var="//192.168.0.11/Backup_EmonPi  /media/Emoncms_backup_diario cifs username=emonpi,password=pi 0 0"
[ $(grep -c "$var" /etc/fstab) -eq 0 ] && echo -e "\n$var" | sudo tee -a /etc/fstab
sudo mount -a
#df -h
#crontab
