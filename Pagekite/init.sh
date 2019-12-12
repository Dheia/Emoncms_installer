#!/bin/bash
sudo apt-get install dirmngr
# Add our repository to /etc/apt/sources.list
echo deb http://pagekite.net/pk/deb/ pagekite main | sudo tee -a /etc/apt/sources.list
# Add the PageKite packaging key to your key-ring
sudo apt-key adv --recv-keys --keyserver keys.gnupg.net AED248B1C7B2CAC3
# Refresh your package sources by issuing
sudo apt-get update
# Install pagekite
sudo apt-get install pagekite
srv="service_on = http:@kitename : localhost:80 : @kitesecret"

if [ -f /etc/pagekite.d/10_account.rc ]
then
    cd /etc/pagekite.d
    while true; do
        read -p "Enter kitename (xxx.pagekite.me): " var
        if [[ $var == *pagekite.me ]];then
            break
        else echo "Error input contains non pagekite.me form"
        fi
    done
    sudo sed -i "s/^kitename *=.*$/kitename   = $var/" 10_account.rc
    read -p "please enter the kitesecret: " var
    sudo sed -i "s/^kitesecret *=.*$/kitesecret = $var/" 10_account.rc
    sudo sed -i '/# Delete this line!/d' 10_account.rc
    sudo sed -i '/abort_not_configured/d' 10_account.rc
fi

if [ -f /etc/pagekite.d/80_httpd.rc.sample ]
then
    sudo mv 80_httpd.rc.sample 80_httpd.rc
fi

if [ -f /etc/pagekite.d/80_httpd.rc ]
then
    read -p "Enter your domain  (www.xxxx.com): " var
    var="service_on = http:$var : localhost:80 : @kitesecret"
    if [ $(grep -c "$var" 80_httpd.rc) -eq 0 ]
    then
        sudo sed -i "0,/^$srv/s//$var\n&/" 80_httpd.rc
    fi
else
    echo "Error 80_httpd.rc file not found"
fi


if [ -f /etc/pagekite.d/80_sshd.rc.sample ]
then
    sudo mv 80_sshd.rc.sample 81_sshd.rc
fi

sudo service pagekite restart
