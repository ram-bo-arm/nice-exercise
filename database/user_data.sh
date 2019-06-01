#!/bin/bash

sudo apt-get update
sudo apt-get install -y traceroute
sudo echo "${public_key_openssh}" >> /home/ubuntu/.ssh/authorized_keys

# Install MySQL Server in a Non-Interactive mode. Default root password will be "root"
echo "mysql-server-5.7 mysql-server/root_password password root" | sudo debconf-set-selections
echo "mysql-server-5.7 mysql-server/root_password_again password root" | sudo debconf-set-selections
sudo apt-get -y install mysql-server-5.7
sudo systemctl enable mysql

echo "[mysqld]" | sudo tee -a /etc/mysql/my.cnf
echo "bind-address = 10.0.1.10" | sudo tee -a /etc/mysql/my.cnf
#echo "skip-grant-tables" | sudo tee -a /etc/mysql/my.cnf

sudo systemctl restart mysql

mysql -u root --password=root -e "GRANT PROCESS ON *.* to 'web'@'10.0.1.12' IDENTIFIED BY 'web_pass';"
mysql -u root --password=root -e "GRANT PROCESS ON *.* to 'web'@'10.0.1.13' IDENTIFIED BY 'web_pass';"

#export DEBIAN_FRONTEND=noninteractive
#sudo -E apt-get -q -y install mysql-server-5.7
