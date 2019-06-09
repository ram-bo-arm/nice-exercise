#!/bin/bash

sudo echo "${index_html}" | base64 --decode > /var/www/html/index.html
sudo echo "${info_php}" | base64 --decode > /var/www/html/info.php

sudo systemctl enable apache2
sudo systemctl restart apache2

sudo cp /tmp/index.html /var/www/html/index.html
sudo cp /tmp/info.php /var/www/html/info.php
#sudo chmod 777 /var/www/html/index.html
#sudo touch /var/www/html/logo.png
#sudo chmod 777 /var/www/html/logo.png
#sudo cp /tmp/logo.png /var/www/html/logo.png
