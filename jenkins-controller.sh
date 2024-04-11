#!/bin/bash
# sudo yum update -y
# sudo yum upgrade -y
# sudo yum install wget -y
# sudo yum install git -y
# sudo yum install maven -y
# sudo yum install java-11-openjdk -y
# sudo wget https://get.jenkins.io/redhat/jenkins-2.421-1.1.noarch.rpm
# sudo rpm -ivh jenkins-2.421-1.1.noarch.rpm
# sudo yum install jenkins
# sudo systemctl daemon-reload
# sudo systemctl start jenkins
# sudo systemctl enable jenkins
# sudo mkdir /var/lib/jenkins/.ssh/
# sudo chown -R jenkins:jenkins /var/lib/jenkins/.ssh
# sudo chmod 777 /var/lib/jenkins/.ssh
# sudo ssh-keyscan -H ${aws_instance.jenkins-agent.public_ip} >> /var/lib/jenkins/.ssh/known_hosts
# sudo yum install -y yum-utils
# sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
# sudo yum install docker-ce -y
# sudo systemctl enable docker
# sudo systemctl start docker
# sudo usermod -aG docker ec2-user
# sudo chmod 777 /var/run/docker.sock
# docker run -d --name sonarqube -p 9000:9000 -p 9092:9092 sonarqube
# sudo hostnamectl set-hostname Jenkins-controller

#!/bin/bash
sudo apt-get update
sudo apt-get install wget -y
sudo apt-get install git -y
sudo apt-get install maven -y
sudo apt install default-jre -y
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins -y
sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo mkdir /var/lib/jenkins/.ssh/
sudo chown -R jenkins:jenkins /var/lib/jenkins/.ssh
sudo chmod 777 /var/lib/jenkins/.ssh
sudo chown -R ubuntu:ubuntu /etc/hosts
echo "${aws_instance.jenkins-agent.public_ip, --hostname=jenkins-agent}" >> /etc/hosts
sudo ssh-keyscan -H jenkins-agent >> /var/lib/jenkins/.ssh/known_hosts
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-cache policy docker-ce
sudo apt install docker-ce -y
sudo chmod 777 /var/run/docker.sock
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ubuntu
docker run -d --name sonarqube -p 9000:9000 -p 9092:9092 sonarqube
sudo hostnamectl set-hostname Jenkins-controller




# sudo ufw allow 8080
# sudo ufw allow OpenSSH
# sudo ufw enable
# sudo ufw status


# locals {
#   jenkins_user_data = <<-EOF
# EOF
# }

# sudo service sshd restart
# echo "license_key: eu01xx31c21b57a02a5da0d33d8706beb182NRAL" | sudo tee -a /etc/newrelic-infra.yml
# sudo curl -o /etc/yum.repos.d/newrelic-infra.repo https://download.newrelic.com/infrastructure_agent/linux/yum/el/7/x86_64/newrelic-infra.repo
# sudo yum -q makecache -y --disablerepo='*' --enablerepo='newrelic-infra'
# sudo yum install newrelic-infra -y --nobest
# sudo reboot
# sudo usermod -aG docker jenkins
