#!/bin/bash

sudo echo "${jenkins_yaml}" | base64 --decode > /var/lib/jenkins/jenkins.yaml


#aws s3 cp s3://dani-test-jenkins/config/LOCAL_ID /run/secrets/LOCAL_ID
#aws s3 cp s3://dani-test-jenkins/config/LOCAL_PASS /run/secrets/LOCAL_PASS
#aws s3 cp s3://dani-test-jenkins/config/EC2_KEY /run/secrets/EC2_KEY



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


export VAULT_ADDR='http://127.0.0.1:8200'

for i in {1..5}
do
    status="$(systemctl show vault --no-page)"
    sub_state=$(echo "$status" | grep 'SubState=' | cut -f2 -d=)
    if [ "$sub_state" == "running" ]
    then
    	echo "It's running"
    else
        echo "Not running"
    fi

    active_state=$(echo "$status" | grep 'ActiveState=' | cut -f2 -d=)
    if [ "$active_state" == "active" ]
    then
    	echo "It's active"
    else
        echo "Not active"
    fi

    if [ "$sub_state" == "running" ] && [ "$active_state" == "active" ]
    then
    	break
    else
        sleep 1
    fi
done

if [ "$sub_state" != "running" ] || [ "$active_state" != "active" ]
then
        echo "failed to start vault - aborting"
        exit
else
        echo "vault is active and running"
fi

for i in {1..20}
do
    netstat -tlnp
    if [ -z "$(netstat -tlnp 2>/dev/null | grep 8200)" ]
    then
        sleep 1
        if [ $i == 20 ]
        then
            echo "valut server is off -aborting !!!"
            exit
        else
            echo "valut server is off $i/10"
        fi
     else
        echo "valut server listening"
        break
    fi

done


export ROOT_TOKEN=$(sudo -E vault operator init -recovery-shares=1 -recovery-threshold=1 | grep '^Initial' | awk '{print $4}')
echo "logging in "
vault login $ROOT_TOKEN 1>/dev/null 2>/dev/null
vault secrets enable -version=2 kv

local_id=$(aws s3 cp s3://dani-test-jenkins/config/LOCAL_ID -)
local_pass=$(aws s3 cp s3://dani-test-jenkins/config/LOCAL_PASS -)
ec2_key=$(aws s3 cp s3://dani-test-jenkins/config/EC2_KEY -)

vault kv put kv/jenkins local_id="$local_id" local_pass="$local_pass" ec2_key="$ec2_key"

mkdir -p  /run/secrets

echo $local_id > /run/secrets/LOCAL_ID
echo $local_pass > /run/secrets/LOCAL_PASS

vault policy write jenkins-ro -<<EOF
path "kv/data/jenkins" {
   capabilities = ["list","read"]
}
EOF


JENKINS_RO_TOKEN=$(sudo -E vault token create -orphan=true -policy="jenkins-ro" -field="token")

echo "export CASC_VAULT_TOKEN=$JENKINS_RO_TOKEN" > /var/lib/jenkins/.profile
echo "export CASC_VAULT_URL=http://127.0.0.1:8200" >> /var/lib/jenkins/.profile
echo "export CASC_VAULT_PATHS=/kv/jenkins" >> /var/lib/jenkins/.profile

echo $JENKINS_RO_TOKEN | aws s3 cp - s3://dani-test-jenkins/config/jenkins_token

vault token revoke $ROOT_TOKEN


shred ~/.vault-token
unset $ROOT_TOKEN
unset $JENKINS_RO_TOKEN

systemctl enable jenkins
systemctl start jenkins
