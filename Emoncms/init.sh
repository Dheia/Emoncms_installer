#!/bin/bash

user=$USER

source /

[ -d "$openenergymonitor_dir" ] && sudo rm -r $openenergymonitor_dir
sudo mkdir $openenergymonitor_dir
sudo chown $user $openenergymonitor_dir

[ -d "$emoncms_dir" ] && sudo rm -r $emoncms_dir
sudo mkdir $emoncms_dir
sudo chown $user $emoncms_dir

[ -d "$emoncms_www" ] && sudo rm -r $emoncms_www
[ -d "$emoncms_datadir" ] && sudo rm -r $emoncms_datadir

cd $openenergymonitor_dir

git clone https://github.com/openenergymonitor/EmonScripts.git
cd $openenergymonitor_dir/EmonScripts
git checkout stable

cd $openenergymonitor_dir/EmonScripts/install
./main.sh
echo "Emoncms installed successfully..."
