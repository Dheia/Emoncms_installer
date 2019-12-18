while true; do      
  OPTION=$(whiptail --title "Install RFM69Pi Menu Dialog" --menu "Choose your option" 15 60 2 \
    "1" "Raspberry serial port configuration (Reboot required)" \
    "2" "RFM69Pi configuration" 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
      case $OPTION in
        1)
            echo "-------------------------------------------------"
            echo "Raspberry serial port configuration              "
            echo "-------------------------------------------------"
            #Disable Bluetooh
            [ $(grep -c "dtoverlay=pi3-disable-bt$" /boot/config.txt) -eq 0 ] && echo -e "\ndtoverlay=pi3-disable-bt" | sudo tee -a /boot/config.txt
            sudo systemctl disable hciuart
            #
            if [ $(grep -c "enable_uart=" /boot/config.txt) -eq 0 ]
            then
                echo -e "enable_uart=1" | sudo tee -a /boot/config.txt
            else
                sudo sed -i "s/^enable_uart=.*/enable_uart=1/" /boot/config.txt
            fi
            #Disabling Raspbian use of console UART
            sudo sed -i 's/console=serial0,*[^ ]*[ \|$\]*//g' /boot/cmdline.txt
            
            echo "Raspberry serial port configurated successfully ..."
            read -p "Do you want to restart now (y/n): " var
            if [ "$var" = "Y" ] || [ "$var" = "y" ]
            then
                echo "Restarting ...."
                sudo reboot
            fi
            
        ;;
        2)  
            echo "-------------------------------------------------"
            echo "RFM69Pi configuration"
            echo "-------------------------------------------------"
            stty -F /dev/ttyAMA0 speed 38400 cs8 -cstopb -parenb raw
            echo -e "\nRFM69Pi"
            echo "1) Main Mode ->  Node:5, Group:210, 433Mhz, Send ACKs: on"
            echo "2) Test Mode ->  Node:6, Group:210, 433Mhz, Send ACKs: off"
            read -p "Choose number option: " var
            
            case $var in
            1)
              echo -ne "5i" > /dev/ttyAMA0
              echo -ne "210g" > /dev/ttyAMA0
              echo -ne "4b" > /dev/ttyAMA0
              echo -ne "0c" > /dev/ttyAMA0  #collect mode  send acks
              echo -ne "1q" > /dev/ttyAMA0  #show only valid packets
              echo "RFM69Pi configurated successfully ..."
            ;;
            2)
              echo -ne "6i" > /dev/ttyAMA0
              echo -ne "210g" > /dev/ttyAMA0
              echo -ne "4b" > /dev/ttyAMA0
              echo -ne "1c" > /dev/ttyAMA0  #collect mode do not send acks
              echo -ne "1q" > /dev/ttyAMA0  #show only valid packets
              echo "RFM69Pi configurated successfully ..."
            ;;
            *)
              echo "Invalid option"
             ;;
             esac
             read -p "Do you want to open minicom (y/n): " var
             if [ "$var" = "Y" ] || [ "$var" = "y" ]
             then
                minicom -b 38400 -D /dev/ttyAMA0
             fi
        ;;
      esac
    else
      break
    fi
done
