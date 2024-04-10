# locals {
#   nfs-server_user_data = <<-EOF
# #!/bin/bash
# sudo apt update
# sudo apt install -y nfs-kernel-server
# sudo systemctl start nfs-kernel-server
# sudo systemctl enable nfs-kernel-server
# sudo mkdir /srv/nfs/kubedata -p
# sudo chown ubuntu:ubuntu /srv/nfs/kubedata
# sudo chmod 600 /srv/nfs/kubedata
# echo "/srv/nfs/kubedata ${aws_instance.worker-node1.public_ip}(rw,sync,no_subtree_check,no_root_squash,insecure) ${aws_instance.worker-node2.public_ip}(rw,sync,no_subtree_check,no_root_squash,insecure)" >> /etc/exports
# sudo exportfs -rav
# sudo systemctl restart nfs-kernel-server
# sudo hostnamectl set-hostname nfs-server
# EOF
# }
