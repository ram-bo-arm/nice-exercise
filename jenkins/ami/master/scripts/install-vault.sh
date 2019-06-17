#!/bin/bash

# script taken from:
# https://github.com/hashicorp/vault-guides/blob/master/operations/aws-kms-unseal/terraform-aws/userdata.tpl

sudo apt-get install -y unzip
# apt-get install -y libtool libltdl-dev 

USER="vault"
COMMENT="Hashicorp vault user"
GROUP="vault"
HOME="/srv/vault"

# Detect package management system.
YUM=$(which yum 2>/dev/null)
APT_GET=$(which apt-get 2>/dev/null)

user_rhel() {
  # RHEL user setup
  sudo /usr/sbin/groupadd --force --system ${GROUP}

  if ! getent passwd ${USER} >/dev/null ; then
    sudo /usr/sbin/adduser \
      --system \
      --gid ${GROUP} \
      --home ${HOME} \
      --no-create-home \
      --comment "$${COMMENT}" \
      --shell /bin/false \
      ${USER}  >/dev/null
  fi
}

user_ubuntu() {
  # UBUNTU user setup
  if ! getent group ${GROUP} >/dev/null
  then
    sudo addgroup --system ${GROUP} >/dev/null
  fi

  if ! getent passwd ${USER} >/dev/null
  then
    sudo adduser \
      --system \
      --disabled-login \
      --ingroup ${GROUP} \
      --home ${HOME} \
      --no-create-home \
      --gecos "${COMMENT}" \
      --shell /bin/false \
      ${USER}  >/dev/null
  fi
}

if [[ ! -z ${YUM} ]]; then
  logger "Setting up user ${USER} for RHEL/CentOS"
  user_rhel
elif [[ ! -z ${APT_GET} ]]; then
  logger "Setting up user ${USER} for Debian/Ubuntu"
  user_ubuntu
else
  logger "${USER} user not created due to OS detection failure"
  exit 1;
fi

logger "User setup complete"



VAULT_ZIP="vault.zip"
VAULT_URL="https://releases.hashicorp.com/vault/1.1.2/vault_1.1.2_linux_amd64.zip"
curl --silent --output /tmp/${VAULT_ZIP} ${VAULT_URL}
sudo unzip -o /tmp/${VAULT_ZIP} -d /usr/local/bin/
sudo chmod 0755 /usr/local/bin/vault
sudo chown vault:vault /usr/local/bin/vault
sudo mkdir -pm 0755 /etc/vault.d
sudo mkdir -pm 0755 /opt/vault
sudo chown vault:vault /opt/vault


cat << EOF | sudo tee -a /lib/systemd/system/vault.service
[Unit]
Description=Vault Agent
Requires=network-online.target
After=network-online.target
[Service]
Restart=on-failure
PermissionsStartOnly=true
ExecStartPre=/sbin/setcap 'cap_ipc_lock=+ep' /usr/local/bin/vault
ExecStart=/usr/local/bin/vault server -config /etc/vault.d
ExecReload=/bin/kill -HUP $MAINPID
KillSignal=SIGTERM
User=vault
Group=vault
[Install]
WantedBy=multi-user.target
EOF

##########################
#config file (vault.hcl) will be added in the user data section of the instance
#cat << EOF > /etc/vault.d/vault.hcl
#storage "file" {
#  path = "/opt/vault"
#}
#listener "tcp" {
#  address     = "0.0.0.0:8200"
#  tls_disable = 1
#}
#seal "awskms" {
#  region     = "${aws_region}"
#  kms_key_id = "${kms_key}"
#}
#ui=true
#EOF


sudo chmod 0664 /lib/systemd/system/vault.service
#systemctl daemon-reload
#sudo chown -R vault:vault /etc/vault.d
#sudo chmod -R 0644 /etc/vault.d/*

cat << EOF | sudo tee -a /etc/profile.d/vault.sh
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_SKIP_VERIFY=true
EOF

#systemctl enable vault
#systemctl start vault
