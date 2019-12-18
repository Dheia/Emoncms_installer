#!/bin/bash

source ../config.ini
config_file="$emoncms_dir/modules/backup/config.cfg"
log="$emoncms_log_location/exportbackup.log"

echo "-------------------------------------------------"
echo "Mod backup module installation                   "
echo "-------------------------------------------------"

if [ -f $config_file ]
then
  source $config_file
  #Used for import export scripts to show progress bar
  echo "Installing PV progress bar ...."
  sudo apt-get install pv
  #Replace import,export script with mod version
  echo "Copying to backup folder import & export modified scripts"
  cd $backup_script_location
  [ -f "emoncmcs-export.sh" ] && rm emoncmcs-export.sh
  [ -f "emoncmcs-import.sh" ] && rm emoncmcs-import.sh
  cp $openenergymonitor_mod/Emoncms-Scripts/Backup/emoncms-import.sh $backup_script_location
  cp $openenergymonitor_mod/Emoncms-Scripts/Backup/emoncms-export.sh $backup_script_location
  
  echo "Setting Fstab file to mount NAS folder Backup_EmonPi ..."
  # Set Fstab file to mount NAS folder Backup_EmonPi
  
  [ !-d "$nas_device" ] && sudo mkdir $nas_mount
  smb="$nas_device  $nas_mount cifs username=emonpi,password=pi 0 0"
  [ $(grep -c "$smb" /etc/fstab) -eq 0 ] && echo -e "\n$smb" | sudo tee -a /etc/fstab
  sudo mount -a

  #Cron settings export backup automatically at 4:00
  echo "Setting backup job to cron to export backup automatically ..."
  #Using service-runner
  #redis-cli RPUSH service-runner "$backup_script_location/emoncms-export.sh /tmp/emoncms-flag-import>$log"
  job_bkp="00 4 * * * ${backup_script_location}/emoncms-export.sh>${backup_script_location}/emoncms-export.log 2>&1"
  #Using export script directly
  #job_bkp="00 4 * * * $backup_script_location/emoncms-export.sh >> $backup_script_location/emoncms-export.log 2>&1"
  crontab -l | grep -Fq "$job_bkp"  || (crontab -l ; echo "$job_bkp" ) | crontab -
  #df -h
else
  echo "ERROR: Backup $config_file file does not exist"
  exit 1
fi
