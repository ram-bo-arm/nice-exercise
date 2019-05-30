#!/bin/bash

sudo apt-get update

sudo apt-get install -y traceroute
sudo apt-get install -y apache2
sudo apt-get install -y php libapache2-mod-php php-mysql
sudo apt-get install -y mysql-client-core-5.7
sudo apt-get install -y libssh2-1 php-ssh2

sudo systemctl enable apache2
sudo systemctl restart apache2

sudo mkdir /var/www/.ssh
sudo echo "${private_key_pem}" >> /var/www/.ssh/web_key
sudo echo "${public_key_pem}" >> /var/www/.ssh/web_key.pem
sudo echo "${public_key_openssh}" >> /var/www/.ssh/web_key.openssh

sudo cp /tmp/index.html /var/www/html/index.html
sudo cp /tmp/info.php /var/www/html/info.php
#sudo chmod 777 /var/www/html/index.html
#sudo touch /var/www/html/logo.png
#sudo chmod 777 /var/www/html/logo.png
sudo cp /tmp/logo.png /var/www/html/logo.png
