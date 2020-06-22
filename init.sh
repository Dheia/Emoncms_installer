#!/bin/bash
openenergymonitor_mod=/opt/openenergymonitor_mod
user=$USER

clear
#echo "-------------------------------------------------"
#echo "Updating system and installing git package       "
#echo "-------------------------------------------------"
#sudo apt-get update && sudo apt-get upgrade
#sudo apt-get dist-upgrade -y && sudo apt-get clean
#sudo apt --fix-broken install
sudo apt-get install -y git

echo "Creating openenergymonitor_mod folder in /opt/ ...."
[ -d "$openenergymonitor_mod" ] && sudo rm -r $openenergymonitor_mod
sudo mkdir -p "$openenergymonitor_mod"
sudo chown $user $openenergymonitor_mod

cd $openenergymonitor_mod

echo "Cloning Emoncms-Scripts repository in openenergymonitor_mod folder ...."
git clone https://github.com/jatg81/Emoncms-Scripts.git
cd $openenergymonitor_mod/Emoncms-Scripts
git checkout master
rm init.sh

while true; do      
  OPTION=$(whiptail --title "Install Menu Dialog" --menu "Choose your option" 15 60 9 \
    "1" "Install HDD usb (reboot required)" \
    "2" "Install RFM69Pi (reboot required)" \
    "3" "Install Emoncms" \
    "4" "Install UPSPico" \
    "5" "Install NodeRed" \
    "6" "Install PageKite" \
    "7" "Install Backup Module mod" \
    "8" "Disable led Rpi & RFM69Pi" \
    "9" "Enable SSH root access"  3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
      case $OPTION in
        1)
            cd $openenergymonitor_mod/Emoncms-Scripts/USB_HDD
            chmod +x usb_hdd
            sudo ./usb_hdd -d /dev/sda
        ;;
        2)
            cd $openenergymonitor_mod/Emoncms-Scripts/RFM69Pi
            chmod +x init.sh && ./init.sh
        ;;
        3)
            cd $openenergymonitor_mod/Emoncms-Scripts/Emoncms
            chmod +x init.sh && ./init.sh
        ;;
        4)  
            cd $openenergymonitor_mod/Emoncms-Scripts/UPS_Pico
            chmod +x init.sh && ./init.sh
        ;;
        5)
            cd $openenergymonitor_mod/Emoncms-Scripts/Node-RED
            chmod +x init.sh && ./init.sh
        ;;
        6)
            cd $openenergymonitor_mod/Emoncms-Scripts/Pagekite
            chmod +x init.sh && ./init.sh
        ;;
        7)
            cd $openenergymonitor_mod/Emoncms-Scripts/Backup
            chmod +x init.sh && ./init.sh
        ;;
        8)
            cd $openenergymonitor_mod/Emoncms-Scripts/RPi_Dark_mode
            chmod +x init.sh && ./init.sh
        ;;
        9)
            cd $openenergymonitor_mod/Emoncms-Scripts/SSH_rootaccess
            chmod +x init.sh && ./init.sh
        ;;
      esac
    else
      exit
    fi
done
