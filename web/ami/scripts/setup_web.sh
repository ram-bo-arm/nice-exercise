#!/bin/bash


echo "www-data  ALL=(ALL) NOPASSWD: /usr/bin/traceroute" | sudo tee -a /etc/sudoers

sudo apt-get update

#sudo apt-get install -y traceroute
sudo apt-get install -y inetutils-traceroute
sudo apt-get install -y apache2
sudo apt-get install -y php libapache2-mod-php php-mysql
sudo apt-get install -y mysql-client-core-5.7
sudo apt-get install -y libssh2-1 php-ssh2
