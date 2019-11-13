nas_mount="/media/Emoncms_backup_diario"
nas_device="//192.168.0.11/Backup_EmonPi"
nas_user="emonpi"
nas_pass="pi"

if [ -f $emoncms_dir/modules/backup/config.cfg ]

#Replace import,export script with mod version
cd $backup_script_location
[ -f "emoncmcs-export.sh" ] && rm emoncmcs-export.sh
[ -f "emoncmcs-import.sh" ] && rm emoncmcs-import.sh
cp $openenergymonitor_dir/Emoncms-Scripts/Backup/emoncmcs-export.sh $backup_script_location
cp $openenergymonitor_dir/Emoncms-Scripts/Backup/emoncmcs-import.sh $backup_script_location

# Set Fstab file to mount NAS folder Backup_EmonPi
smb="$nas_device  $nas_mount cifs username=emonpi,password=pi 0 0"
[ $(grep -c "$smb" /etc/fstab) -eq 0 ] && echo -e "\n$smb" | sudo tee -a /etc/fstab
sudo mount -a

#Cron settings export backup automatically at 4:00
#job_bkp=00 4 * * * $backup_script_location/emoncms-export.sh >> $backup_location/emoncms-export.log 2>&1
#Using service-runner
job_bkp="00 4 * * * ${backup_script_location}/emoncms-export.sh>${backup_script_location}/emoncms-export.log 2>&1"
crontab -l | grep -Fq "$job_bkp"  || (crontab -l ; echo "$job_bkp" ) | crontab -
#df -h
