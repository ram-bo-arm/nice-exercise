#!/bin/bash


sudo add-apt-repository ppa:openjdk-r/ppa

sudo apt-get update
sudo apt-get install -y openjdk-8-jdk
sudo update-alternatives --config java

if [ -z $(which java) ]
then
	sudo apt-get install -y openjdk-8-jdk
	sudo update-alternatives --config java
else
	echo "java already installed"
fi

# jenkins version being bundled in this docker image
#JENKINS_VERSION='2.138.2'

# jenkins.war checksum, download will be validated using it
#JENKINS_SHA=d8ed5a7033be57aa9a84a5342b355ef9f2ba6cdb490db042a6d03efb23ca1e83
#ARG JENKINS_SHA=014f669f32bc6e925e926e260503670b32662f006799b133a031a70a794c8a14
# Can be used to customize where jenkins.war get downloaded from
#JENKINS_URL=https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/${JENKINS_VERSION}/jenkins-war-${JENKINS_VERSION}.war

#echo JENKINS_URL=${JENKINS_URL}
# could use ADD but this one does not check Last-Modified header neither does it allow to control checksum 
# see https://github.com/docker/docker/issues/8331
#sudo curl -fsSL ${JENKINS_URL} -o /tmp/jenkins.war
#sudo mkdir  /usr/share/jenkins
#sudo mv /tmp/jenkins.war  /usr/share/jenkins/jenkins.war
#&& echo "${JENKINS_SHA}  /usr/share/jenkins/jenkins.war" | sha256sum -c -


wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -

sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

sudo apt-get update

sudo apt-get install -y python unzip
sudo apt-get install -y awscli


wget https://pkg.jenkins.io/debian-stable/binary/jenkins_2.176.1_all.deb -O /tmp/jenkins_2.164.3_all.deb

sudo apt-get install -y /tmp/jenkins_2.164.3_all.deb

sudo sed -i s/JAVA_ARGS=\"-Djava.awt.headless=true\"/JAVA_ARGS=\""-Djava.awt.headless=true -Djenkins.install.runSetupWizard=false\""/g /etc/default/jenkins

sudo mkdir /var/lib/jenkins/init.groovy.d

sudo cp /tmp/disable_initial_wizard.groovy /var/lib/jenkins/init.groovy.d/disable_initial_wizard.groovy

sudo systemctl disable jenkins

#sudo rm /var/lib/jenkins/init.groovy.d/disable_initial_wizard.groovy
