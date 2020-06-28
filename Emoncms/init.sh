#!/bin/bash

source ../config.ini

user=$USER
[ -d "$openenergymonitor_dir" ] && sudo rm -r $openenergymonitor_dir
sudo mkdir $openenergymonitor_dir
sudo chown $user $openenergymonitor_dir

[ -d "$emoncms_dir" ] && sudo rm -r $emoncms_dir
sudo mkdir $emoncms_dir
sudo chown $user $emoncms_dir

[ -d "$emoncms_www" ] && sudo rm -r $emoncms_www
[ -d "$emoncms_datadir" ] && sudo rm -r $emoncms_datadir

cd $openenergymonitor_dir

git clone https://github.com/openenergymonitor/EmonScripts.git
cd $openenergymonitor_dir/EmonScripts
git checkout stable

cp $openenergymonitor_mod/Emoncms-Scripts/config.ini $openenergymonitor_dir/EmonScripts/install/config.ini
sudo chmod +x  $openenergymonitor_dir/EmonScripts/install/emoncms_emonpi_modules.sh

cd $openenergymonitor_dir/EmonScripts/install
./main.sh

read -p "Do you want to replace process_processlist.php modified version?(y/n): " var
             if [ "$var" = "Y" ] || [ "$var" = "y" ]
             then
                cp $openenergymonitor_mod/Emoncms-Scripts/Emoncms/process_processlist.php /var/www/emoncms/Modules/process/
             fi

echo "Emoncms installed successfully..."
