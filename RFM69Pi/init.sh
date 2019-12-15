
[ $(grep -c "dtoverlay=pi3-disable-bt$" /boot/config.txt) -eq 0 ] && echo -e "\ndtoverlay=pi3-disable-bt" | sudo tee -a /boot/config.txt
if [ $(grep -c "enable_uart=" /boot/config.txt) -eq 0 ]
then
    echo -e "enable_uart=1" | sudo tee -a /boot/config.txt
else
    sudo sed -i "s/^enable_uart=.*/enable_uart=1/" /boot/config.txt
fi
sudo sed -i 's/console=serial0,*[^ ]*[ \|$\]*//g' /boot/cmdline.txt
sudo systemctl disable hciuart
sudo apt install minicom -y


stty -F /dev/ttyAMA0 speed 38400 cs8 -cstopb -parenb raw
echo -ne "6i" > /dev/ttyAMA0
echo -ne "210g" > /dev/ttyAMA0
echo -ne "4b" > /dev/ttyAMA0
echo -ne "1c" > /dev/ttyAMA0  #collect mode 1c dont send acks
echo -ne "1q" > /dev/ttyAMA0

minicom -b 38400 -D /dev/ttyAMA0
