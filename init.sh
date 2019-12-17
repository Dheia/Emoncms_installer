#!/bin/bash
openenergymonitor_dir=/opt/openenergymonitor_mod
sudo apt-get update && sudo apt-get upgrade 
sudo apt-get install -y git

echo "Creating openenergymonitor_mod folder in /opt/ ...."
[ -d "$openenergymonitor_dir" ] && sudo rm -r $openenergymonitor_dir
sudo mkdir -p "$openenergymonitor_dir"

cd $openenergymonitor_dir

echo "Cloning Emoncms-Scripts repository in openenergymonitor_mod folder ...."
sudo git clone https://github.com/jatg81/Emoncms-Scripts.git
cd $openenergymonitor_dir/Emoncms-Scripts
git checkout master
sudo rm init.sh

while true; do      
  OPTION=$(whiptail --title "Install Menu Dialog" --menu "Choose your option" 15 60 8 \
    "1" "Install RFM69Pi" \
    "2" "Install Emoncms" \
    "3" "Install UPSPico" \
    "4" "Install NodeRed" \
    "5" "Install HDD usb" \
    "6" "Install PageKite" \
    "7" "Install Backup_mod" \
    "8" "Enable SSH root access"  3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
      case $OPTION in
        1)
            cd $openenergymonitor_dir/Emoncms-Scripts/RFM69Pi
            sudo chmod +x init.sh && ./init.sh
        ;;
        2)
            cd /opt
            wget https://raw.githubusercontent.com/openenergymonitor/EmonScripts/stable/install/init.sh
            sudo chmod +x init.sh && ./init.sh
            sudo rm init.sh
            
        ;;
        3)  
            cd $openenergymonitor_dir/Emoncms-Scripts/UPS_Pico
            sudo chmod +x init.sh && ./init.sh
        ;;
        4)
            cd $openenergymonitor_dir/Emoncms-Scripts/Node-RED
            sudo chmod +x init.sh && ./init.sh
        ;;
        5)
            cd $openenergymonitor_dir/Emoncms-Scripts/USB_HDD
            sudo chmod +x usb_hdd
            sudo  ./usb_hdd -d /dev/sda
        ;;
        6)
            cd $openenergymonitor_dir/Emoncms-Scripts/Pagekite
            sudo chmod +x init.sh && ./init.sh
        ;;
        7)
            cd $openenergymonitor_dir/Emoncms-Scripts/Backup
            sudo chmod +x init.sh && ./init.sh
        ;;
        8)
            cd $openenergymonitor_dir/Emoncms-Scripts/SSH_root
            sudo chmod +x init.sh && ./init.sh
        ;;
      esac
    else
      exit
    fi
done
