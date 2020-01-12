if [ $(grep -c "sudo sh -c 'echo 0 > /sys/class/leds/led1/brightness'" /etc/rc.local) -ne 0 ]
then
    read -p "Do you want to disable dark mode? y/n :  " var
    if [ "$var" = "Y" ] || [ "$var" = "y" ]
    then
         sudo sh -c 'echo 1 > /sys/class/leds/led1/brightness'
         sudo sh -c 'echo 1 > /sys/class/leds/led0/brightness'
         sudo sed -i "/sudo sh -c 'echo 0 > \/sys\/class\/leds\/led1\/brightness'/d" /etc/rc.local
         sudo sed -i "/sudo sh -c 'echo 0 > \/sys\/class\/leds\/led0\/brightness'/d" /etc/rc.local
         echo -ne "1l" > /dev/ttyAMA0
    fi
else
    read -p "Do you want to enable dark mode? y/n :  " var
    if [ "$var" = "Y" ] || [ "$var" = "y" ]
    then
         sudo sh -c 'echo 0 > /sys/class/leds/led1/brightness'
         sudo sh -c 'echo 0 > /sys/class/leds/led0/brightness'
         sudo sed -i "/^exit 0/i sudo sh -c 'echo 0 > \/sys\/class\/leds\/led1\/brightness'" /etc/rc.local
         sudo sed -i "/^exit 0/i sudo sh -c 'echo 0 > \/sys\/class\/leds\/led0\/brightness'" /etc/rc.local
         echo -ne "0l" > /dev/ttyAMA0
    fi
fi
