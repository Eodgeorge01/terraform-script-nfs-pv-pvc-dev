# locals {
#   jenkins_user_data2 = <<-EOF
# #!/bin/bash
# sudo yum update -y
# sudo yum upgrade -y
# sudo yum install wget -y
# sudo yum install git -y
# sudo yum install maven -y
# sudo yum install java-11-openjdk -y
# sudo yum install -y yum-utils
# sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
# sudo yum install docker-ce -y
# sudo systemctl enable docker
# sudo systemctl start docker
# sudo usermod -aG docker ec2-user
# sudo chmod 777 /var/run/docker.sock
# sudo hostnamectl set-hostname Jenkins-agent
# EOF
# }

locals {
  jenkins_user_data2 = <<-EOF
#!/bin/bash
sudo apt-get update
sudo apt-get install wget -y
sudo apt-get install git -y
sudo apt-get install maven -y
sudo apt install default-jre -y
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-cache policy docker-ce -y
sudo apt install docker-ce -y
sudo chmod 777 /var/run/docker.sock
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ubuntu
sudo hostnamectl set-hostname Jenkins-agent
EOF
}