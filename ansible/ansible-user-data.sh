#!/bin/bash
sudo apt update
sudo apt install software-properties-common -y
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y
sudo apt install python3-pip -y
sudo -E pip3 install pexpect -y
echo "${prv-key}" >> /home/ubuntu/keypair.pem
sudo chown -R ubuntu:ubuntu /home/ubuntu/keypair.pem
chmod 600 /home/ubuntu/keypair.pem
sudo chown -R ubuntu:ubuntu /etc/ansible/
echo "${ansible-target-ip} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/keypair.pem" >> /etc/ansible/hosts
sudo chown -R ubuntu:ubuntu /etc/ssh/
sudo bash -c 'echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config'
echo "${file("./ansible/playbooks/webserver.yaml")}" >> /home/ubuntu/webserver.yaml
sudo hostnamectl set-hostname ansible-host
  
  
  
  
  # locals {
  #   ansible_user_data = <<-EOF
  # EOF
  # }