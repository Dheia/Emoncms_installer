#!/bin/bash
config_file="/opt/emoncms/modules/backup/config.cfg"
log="/var/log/emoncms/exportbackup.log"

if [ -f $config_file ]
then
  source $config_file
  #Used for import export scripts to show progress bar
  sudo apt-get install pv
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
  #Using service-runner
  #redis-cli RPUSH service-runner "$backup_script_location/emoncms-export.sh /tmp/emoncms-flag-import>$log"
  job_bkp="00 4 * * * ${backup_script_location}/emoncms-export.sh>${backup_script_location}/emoncms-export.log 2>&1"
  #Using export script directly
  #job_bkp=00 4 * * * $backup_script_location/emoncms-export.sh >> $backup_location/emoncms-export.log 2>&1
  crontab -l | grep -Fq "$job_bkp"  || (crontab -l ; echo "$job_bkp" ) | crontab -
  #df -h
else
  echo "ERROR: Backup $config_file file does not exist"
  exit 1
fi
