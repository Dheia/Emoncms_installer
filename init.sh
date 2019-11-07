#!/bin/bash

user=$USER
openenergymonitor_dir=/opt/openenergymonitor_mod

sudo apt-get update -y
sudo apt-get install -y git-core

sudo mkdir $openenergymonitor_dir
sudo chown $user $openenergymonitor_dir

cd $openenergymonitor_dir

git clone https://github.com/jatg81/Emoncms-Scripts.git
cd $openenergymonitor_dir/Emoncms-Scripts
git checkout master

sudo chmod +x init.sh && ./init.sh

./main.sh

cd UPS_Pico
sudo chmod +x init.sh && ./init.sh
