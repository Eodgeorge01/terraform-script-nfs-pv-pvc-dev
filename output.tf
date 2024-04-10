# output "master-node-ip" {
#   value = aws_instance.master-node.public_ip
# }

# output "worker-node1-ip" {
#   value = aws_instance.worker-node1.public_ip
# }

# output "worker-node2-ip" {
#   value = aws_instance.worker-node2.public_ip
# }

# output "nfs-server-ip" {
#   value = aws_instance.nfs-server.public_ip
# }


output "jenkins-controller-ip" {
  value = aws_instance.jenkins-controller.public_ip
}

output "jenkins-agent-ip" {
  value = aws_instance.jenkins-agent.public_ip
}

output "ansible-ip" {
  value = aws_instance.ansible.public_ip
}

output "web-server" {
  value = aws_instance.web-server.public_ip
}


# output "sonarqube-ip" {
#   value = aws_instance.sonarqube.public_ip
# }

# output "ec2-instance" {
#   value = aws_instance.ec2-instance.public_ip
# }