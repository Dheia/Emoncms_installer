kitename="dv-home303.pagekite.me"
kitesecret="299d2c2k3bc8bx7aacfxfxczb8ce47z4"

sudo apt-get install dirmngr
# Add our repository to /etc/apt/sources.list
echo deb http://pagekite.net/pk/deb/ pagekite main | sudo tee -a /etc/apt/sources.list
# Add the PageKite packaging key to your key-ring
sudo apt-key adv --recv-keys --keyserver keys.gnupg.net AED248B1C7B2CAC3
# Refresh your package sources by issuing
sudo apt-get update
# Install pagekite
sudo apt-get install pagekite
