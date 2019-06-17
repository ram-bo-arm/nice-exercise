#!/bin/bash

sudo echo "${jenkins_yaml}" | base64 --decode > /var/lib/jenkins/jenkins.yaml


aws s3 cp s3://dani-test-jenkins/config/LOCAL_ID /run/secrets/LOCAL_ID
aws s3 cp s3://dani-test-jenkins/config/LOCAL_PASS /run/secrets/LOCAL_PASS
aws s3 cp s3://dani-test-jenkins/config/EC2_KEY /run/secrets/EC2_KEY



##############################################
#complete configuraiton of the vault
cat << EOF > /etc/vault.d/vault.hcl
storage "file" {
  path = "/opt/vault"
}
listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = 1
}
seal "awskms" {
  region     = "${aws_region}"
  kms_key_id = "${kms_key}"
}
ui=true
EOF


systemctl daemon-reload

sudo chown -R vault:vault /etc/vault.d
sudo chmod -R 0644 /etc/vault.d/*


systemctl enable vault
systemctl start vault

##############################################

#sudo chmod 777 /var/www/html/index.html
#sudo touch /var/www/html/logo.png
#sudo chmod 777 /var/www/html/logo.png
#sudo cp /tmp/logo.png /var/www/html/logo.png
