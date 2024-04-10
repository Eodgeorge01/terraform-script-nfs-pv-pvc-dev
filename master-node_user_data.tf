# locals {
#   master-node_user_data = <<-EOF
# #!/bin/bash
# sudo apt update
# sudo apt install -y nfs-common
# sudo systemctl daemon-reload
# sudo systemctl start nfs-common
# sudo systemctl enable nfs-common
# sudo mkdir /tmp/data_ -p
# sudo mkdir /tmp/data -p
# sudo sed -e 's/^.*PermitRootLogin prohibit-password/PermitRootLogin yes/g' -i  /etc/ssh/sshd_config
# sudo systemctl restart sshd
# sudo sed -i ‘s/^SELINUX=enforcing$/SELINUX=permissive/’ /etc/selinux/config
# sudo swapoff -a; sudo sed -i '/swap/d' /etc/fstab
# sudo systemctl disable --now ufw
# sudo bash -c 'cat <<EOT >> /etc/modules-load.d/containerd.conf
# overlay
# br_netfilter
# EOT'
# sudo modprobe overlay
# sudo modprobe br_netfilter
# sudo bash -c 'cat <<EOT >> /etc/sysctl.d/kubernetes.conf
# net.bridge.bridge-nf-call-ip6tables = 1
# net.bridge.bridge-nf-call-iptables = 1
# net.ipv4.ip_forward = 1
# EOT'
# sudo sysctl --system
# sudo apt-get update
# sudo apt install -y curl gnupg-agent software-properties-common apt-transport-https ca-certificates
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
# echo "deb [signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io
# sudo mkdir -p -m 755 /etc/apt/keyrings
# curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
# echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
# sudo apt update && sudo apt install -y kubelet kubeadm kubectl
# sudo apt-mark hold kubelet kubeadm kubectl
# sudo rm /etc/containerd/config.toml
# sudo systemctl restart containerd
# sudo hostnamectl set-hostname master-node
# sudo su -c "sudo kubeadm init --pod-network-cidr=10.0.1.0/16" ubuntu >> /home/ubuntu/k8s.txt
# mkdir -p /home/ubuntu/.kube
# sudo cp -i /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
# sudo chown -R ubuntu:ubuntu /home/ubuntu/.kube/config
# echo "${file("./deployment.yaml")}" >> /home/ubuntu/deployment.yaml
# echo "${file("./gp-application.yaml")}" >> /home/ubuntu/gp-application.yaml
# echo "${file("./pvc.yaml")}" >> /home/ubuntu/pvc.yaml
# echo "${file("./pv.yaml")}" >> /home/ubuntu/pv.yaml
# echo "${file("./svc.yaml")}" >> /home/ubuntu/svc.yaml
# echo "${file("./hpa.yaml")}" >> /home/ubuntu/hpa.yaml
# sudo su -c "kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml" ubuntu
# sudo apt install etcd-client
# sudo apt install siege
# cat << EOT > /etc/profile.d/nfs-server.sh
# export NFS_IP="${aws_instance.nfs-server.public_ip}"
# EOT
# curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
# chmod 700 get_helm.sh
# ./get_helm.sh
# EOF
# }



# wget https://get.helm.sh/helm-v3.14.2-linux-amd64.tar.gz
# tar -zxvf helm-v3.14.2-linux-amd64.tar.gz
# sudo mv linux-amd64/helm /usr/local/bin/helm
# sudo rm helm-v3.14.2-linux-amd64.tar.gz
# sudo rm -rf linux-amd64
# curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add --
# echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
# sudo systemctl enable kubelet && sudo systemctl start kubelet
# sudo apt-mark hold kubelet kubeadm kubectl
#sudo apt update && sudo apt install -y kubelet kubeadm kubectl kubernetes-cni
#sudo /lib/systemd/system/nfs-common.service
#sudo su -c "kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml" ubuntu > /home/ubuntu/metric-server.txt
#kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/high-availability-1.21+.yaml

