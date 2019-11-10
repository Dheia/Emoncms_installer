var="//192.168.0.11/home/03_OpenEnergyMonitor/01_EmonPi/01_Backup_diario  /media/Emoncms_backup_diario cifs username=jatg,password=$pass 0 0"
cd $emoncms/modules/backup
[ -f "emoncmcs-export.sh" ] && rm emoncmcs-export.sh
[ -f "emoncmcs-import.sh" ] && rm emoncmcs-import.sh

cp $openenergymonitor_dir/Emoncms-Scripts/Backup/emoncmcs-export.sh $emoncms/modules/backup
cp $openenergymonitor_dir/Emoncms-Scripts/Backup/emoncmcs-import.sh $emoncms/modules/backup

[ $(grep -c $var /etc/fstab) -eq 0 ] &&  echo $var | sudo tee -a /etc/fstab

#crontab
