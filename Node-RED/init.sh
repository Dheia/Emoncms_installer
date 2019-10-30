#!/bin/bash
echo "heyss"
bash <(curl -sL https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered)
echo $?
if [ $? == 0 ]; then
echo "Se instalo nodered"
fi
# sudo systemctl enable nodered.service
