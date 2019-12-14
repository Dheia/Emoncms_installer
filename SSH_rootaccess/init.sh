#!/bin/bash
cd /etc/ssh
sudo sed 's/^PermitRootLogin\s.*$/PermitRootLogin Yes/' sshd_config
sudo service ssh reload
