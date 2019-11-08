#!/bin/bash
echo $PATH
user=$USER
openenergymonitor_dir=/opt/openenergymonitor_mod

sudo apt-get install -y git

echo "Creating openenergymonitor_mod folder in /opt/ ...."
if [ -d "$openenergymonitor_dir" ]; then
    cd  $openenergymonitor_dir
    sudo rm -r *
else
    sudo mkdir -p "$openenergymonitor_dir"
fi
sudo chown $user $openenergymonitor_dir

cd $openenergymonitor_dir

echo "Cloning Emoncms-Scripts repository in openenergymonitor_mod folder ...."
sudo git clone https://github.com/jatg81/Emoncms-Scripts.git
cd $openenergymonitor_dir/Emoncms-Scripts
git checkout master
cd
sudo rm init.sh

while true; do      
  OPTION=$(whiptail --title "Install Menu Dialog" --menu "Choose your option" 15 60 6 \
    "1" "Install UPSPico" \
    "2" "Install NodeRed" \
    "3" "Install HDD usb" \
    "4" "Install PageKite" \
    "5" "Install Backup_mod" \
    "6" "WinSCP root access"  3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
      case $OPTION in
        1)  
            cd $openenergymonitor_dir/Emoncms-Scripts/UPS_Pico
            sudo chmod +x init.sh && ./init.sh
            #echo "Option 1"
            #whiptail --title "Option 1" --msgbox "You chose option 1. Exit status $?" 8 45
        ;;
        2)
            cd $openenergymonitor_dir/Emoncms-Scripts/Node-RED
            sudo chmod +x init.sh && ./init.sh
            #echo "Option 2"
            #whiptail --title "Option 1" --msgbox "You chose option 2. Exit status $?" 8 45
        ;;
        3)
            echo "Option 3"
            whiptail --title "Option 1" --msgbox "You chose option 3. Exit status $?" 8 45
        ;;
      esac
    else
      exit
    fi
done
