#!/bin/bash
clear
openenergymonitor_mod=/opt/openenergymonitor_mod
sudo apt-get update && sudo apt-get upgrade 
sudo apt-get install -y git

echo "Creating openenergymonitor_mod folder in /opt/ ...."
[ -d "$openenergymonitor_mod" ] && sudo rm -r $openenergymonitor_mod
sudo mkdir -p "$openenergymonitor_mod"

cd $openenergymonitor_mod

echo "Cloning Emoncms-Scripts repository in openenergymonitor_mod folder ...."
sudo git clone https://github.com/jatg81/Emoncms-Scripts.git
cd $openenergymonitor_mod/Emoncms-Scripts
sudo git checkout master
sudo rm init.sh

while true; do      
  OPTION=$(whiptail --title "Install Menu Dialog" --menu "Choose your option" 15 60 8 \
    "1" "Install RFM69Pi" \
    "2" "Install Emoncms" \
    "3" "Install UPSPico" \
    "4" "Install NodeRed" \
    "5" "Install HDD usb" \
    "6" "Install PageKite" \
    "7" "Install Backup Module mod" \
    "8" "Enable SSH root access"  3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
      case $OPTION in
        1)
            cd $openenergymonitor_mod/Emoncms-Scripts/RFM69Pi
            sudo chmod +x init.sh && ./init.sh
        ;;
        2)
            cd $openenergymonitor_mod/Emoncms-Scripts/Emoncms
            sudo chmod +x init.sh && ./init.sh
            sudo rm init.sh
            
        ;;
        3)  
            cd $openenergymonitor_mod/Emoncms-Scripts/UPS_Pico
            sudo chmod +x init.sh && ./init.sh
        ;;
        4)
            cd $openenergymonitor_mod/Emoncms-Scripts/Node-RED
            sudo chmod +x init.sh && ./init.sh
        ;;
        5)
            cd $openenergymonitor_mod/Emoncms-Scripts/USB_HDD
            sudo chmod +x usb_hdd
            sudo  ./usb_hdd -d /dev/sda
        ;;
        6)
            cd $openenergymonitor_mod/Emoncms-Scripts/Pagekite
            sudo chmod +x init.sh && ./init.sh
        ;;
        7)
            cd $openenergymonitor_mod/Emoncms-Scripts/Backup
            sudo chmod +x init.sh && ./init.sh
        ;;
        8)
            cd $openenergymonitor_mod/Emoncms-Scripts/SSH_root
            sudo chmod +x init.sh && ./init.sh
        ;;
      esac
    else
      exit
    fi
done
