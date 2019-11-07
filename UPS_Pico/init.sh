sudo apt-get install libcurl4-openssl-dev
sudo pip-3.2 install pycurl
cd package
sudo python setup.py install
cd ../picofssd
sudo python setup.py install
sudo update-rc.d picofssd defaults
sudo update-rc.d picofssd enable
