#!/bin/bash

bash <(curl -sL https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered)
if [ $? == 0 ]; then
  sudo systemctl enable nodered.service
  cd ~/.node-red/node_modules
  npm install node-red-node-wemo
  npm install node-red-contrib-i2c
  npm install node-red-node-emoncms
  npm install node-red-contrib-mi-devices
  npm install node-red-contrib-pid
fi

