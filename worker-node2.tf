locals {
  worker-node2_user_data = <<-EOF
#!/bin/bash
sudo apt update
sudo apt install -y nfs-common
sudo /lib/systemd/system/nfs-common.service
sudo systemctl daemon-reload
sudo systemctl start nfs-common
sudo systemctl enable nfs-common
sudo mkdir /tmp/data_ -p
sudo mkdir /tmp/data -p
sudo sed -e 's/^.*PermitRootLogin prohibit-password/PermitRootLogin yes/g' -i  /etc/ssh/sshd_config
sudo systemctl restart sshd
sudo sed -i ‘s/^SELINUX=enforcing$/SELINUX=permissive/’ /etc/selinux/config
sudo swapoff -a; sudo sed -i '/swap/d' /etc/fstab
sudo systemctl disable --now ufw
sudo bash -c 'cat <<EOT >> /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOT'
sudo modprobe overlay
sudo modprobe br_netfilter
sudo bash -c 'cat <<EOT >> /etc/sysctl.d/kubernetes.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOT'
sudo sysctl --system
sudo apt install -y curl gnupg-agent software-properties-common apt-transport-https ca-certificates
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update && sudo apt install -y kubelet kubeadm kubectl kubernetes-cni
sudo apt-mark hold kubelet kubeadm kubectl
sudo systemctl enable kubelet && systemctl start kubelet
sudo rm /etc/containerd/config.toml
sudo systemctl restart containerd
sudo hostnamectl set-hostname worker-2
EOF
}