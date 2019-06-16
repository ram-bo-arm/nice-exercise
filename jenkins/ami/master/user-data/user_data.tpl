#!/bin/bash

sudo echo "${jenkins_yaml}" | base64 --decode > /var/lib/jenkins/jenkins.yaml


aws s3 cp s3://dani-test-jenkins/config/LOCAL_ID /run/secrets/LOCAL_ID
aws s3 cp s3://dani-test-jenkins/config/LOCAL_PASS /run/secrets/LOCAL_PASS
aws s3 cp s3://dani-test-jenkins/config/EC2_KEY /run/secrets/EC2_KEY


#sudo chmod 777 /var/www/html/index.html
#sudo touch /var/www/html/logo.png
#sudo chmod 777 /var/www/html/logo.png
#sudo cp /tmp/logo.png /var/www/html/logo.png
