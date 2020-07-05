echo "-------------------------------------------------"
echo "UPS Pico installation                            "
echo "-------------------------------------------------"

sudo apt-get install libcurl4-openssl-dev
sudo pip-3.2 install pycurl
sudo apt install python-pip
cd package
sudo python setup.py install
cd ../picofssd
sudo python setup.py install
if [ -f /etc/init.d/picofssd ]; then
  sudo chmod 755 /etc/init.d/picofssd
fi
sudo update-rc.d picofssd defaults
#sudo update-rc.d picofssd enable
echo "UPS_Pico installed successfully..."
