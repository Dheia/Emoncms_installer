#!/bin/bash
sudo rm -r ~/.node-red
bash <(curl -sL https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered)
if [ $? == 0 ]; then
  cd ~/.node-red
  npm install node-red-node-wemo
  npm install https://github.com/nielsnl68/node-red-contrib-i2c.git   #npm install node-red-contrib-i2c
  npm install node-red-node-emoncms
  npm install node-red-contrib-mi-devices
  npm install node-red-contrib-pid
  sudo systemctl enable nodered.service
  sudo service nodered restart
  echo "Node Red installed successfully..."
fi

