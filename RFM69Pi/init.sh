
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
