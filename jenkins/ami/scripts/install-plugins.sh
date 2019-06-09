cd /tmp
sudo ./install-plugins-common.sh $(cat plugins.txt | tr '\n' ' ')
sudo cp jenkins.yaml /var/lib/jenkins/jenkins.yaml
