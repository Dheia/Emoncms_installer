cd $emoncms/modules/backup
[ -f "emoncmcs-export.sh" ] && rm emoncmcs-export.sh
[ -f "emoncmcs-import.sh" ] && rm emoncmcs-import.sh

cp $openenergymonitor_dir/Emoncms-Scripts/Backup/emoncmcs-export.sh $emoncms/modules/backup
cp $openenergymonitor_dir/Emoncms-Scripts/Backup/emoncmcs-import.sh $emoncms/modules/backup

#
