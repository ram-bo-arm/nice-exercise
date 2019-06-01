#!/bin/bash

sudo echo "www-data  ALL=(ALL) NOPASSWD: /usr/bin/traceroute" >> /etc/sudoers

sudo apt-get update

sudo apt-get install -y traceroute
sudo apt-get install -y apache2
sudo apt-get install -y php libapache2-mod-php php-mysql
sudo apt-get install -y mysql-client-core-5.7
sudo apt-get install -y libssh2-1 php-ssh2

sudo echo "${index_html}" | base64 --decode > /var/www/html/index.html
sudo echo "${info_php}" | base64 --decode > /var/www/html/info.php

sudo systemctl enable apache2
sudo systemctl restart apache2

sudo cp /tmp/index.html /var/www/html/index.html
sudo cp /tmp/info.php /var/www/html/info.php
#sudo chmod 777 /var/www/html/index.html
#sudo touch /var/www/html/logo.png
#sudo chmod 777 /var/www/html/logo.png
sudo cp /tmp/logo.png /var/www/html/logo.png
