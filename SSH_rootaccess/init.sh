#!/bin/bash
cd /etc/ssh
sudo sed -i 's/^PermitRootLogin\s.*$/PermitRootLogin Yes/' sshd_config
sudo service ssh reload
