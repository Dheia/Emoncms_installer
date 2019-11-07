#!/bin/bash

user=$USER
openenergymonitor_dir=/opt/openenergymonitor_mod

sudo apt-get update -y
sudo apt-get install -y git-core

sudo mkdir $openenergymonitor_dir
sudo chown $user $openenergymonitor_dir

cd $openenergymonitor_dir

git clone https://github.com/jatg81/Emoncms-Scripts.git
cd $openenergymonitor_dir/Emoncms-Scripts
git checkout master

OPTION=$(whiptail --title "Install Menu Dialog" --menu "Choose your option" 15 60 6 \
"1" "Install UPSPico" \
"2" "Install NodeRed" \
"3" "Install HDD usb" \
"4" "Install PageKite" \
"5" "Install Backup_mod" \
"6" "WinSCP root access"  3>&1 1>&2 2>&3)
 
exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "Your chosen option:" $OPTION
else
    echo "You chose Cancel."
fi

#sudo chmod +x init.sh && ./init.sh
#cd UPS_Pico
#sudo chmod +x init.sh && ./init.sh
