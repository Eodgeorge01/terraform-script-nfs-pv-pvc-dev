# create default vpc
resource "aws_default_vpc" "vpc" {

  tags = {
    Name = "vpc"
  }
}


# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}


# create default subnet 
resource "aws_default_subnet" "az1" {
  availability_zone = data.aws_availability_zones.available_zones.names[0]

  tags = {
    Name = "az1"
  }
}


# # Creating internet gateway
# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_default_vpc.vpc.id

#   tags = {
#     Name = "igw"
#   }
# }

# # Creating Nat Gateway
# resource "aws_nat_gateway" "natgw" {
#   allocation_id = aws_eip.eip.id
#   subnet_id     = aws_default_subnet.az1.id

#   tags = {
#     Name = "natgw"
#   }
# }

#Creating EIP
# resource "aws_eip" "eip" {
#   domain = "vpc"
# depends_on = [aws_internet_gateway.igw]
# }

# #Creating Public Route Table 
# resource "aws_route_table" "route-table" {
#   vpc_id = aws_default_vpc.vpc.id
#   route {
#     cidr_block = "0.0.0.0/0"
#   #  gateway_id = aws_internet_gateway.igw.id
#   }
# }

# #Creating public route table assoc with pub sub
# resource "aws_route_table_association" "ass-sub" {
#   subnet_id      = aws_default_subnet.az1.id
#   route_table_id = aws_route_table.route-table.id
# }

# create security group for the cluster
resource "aws_security_group" "k8s-sg" {
  name        = "k8s-sg"
  description = "allow access on ports 22, 80, 443 and 8080"
  vpc_id      = aws_default_vpc.vpc.id

  # allow access on port 22 
  # ingress {
  #   description = "ssh http and all port access"
  #   from_port   = 22
  #   to_port     = 22
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  # allow access on port
  ingress {
    description = "ssh http and all port access"
    from_port   = 0
    to_port     = 65000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # # nfs port
  # ingress {
  #   description = "nfs port access"
  #   from_port   = 2049
  #   to_port     = 2049
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/30", "0.0.0.0/30"]
  # }

  # # Add the depends_on attribute
  # depends_on = [
  #   aws_instance.worker-node1,
  #   aws_instance.worker-node2,
  #   aws_instance.nfs-server,
  # ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "k8s-sg"
  }
}

#creating a key pair in terraform

resource "tls_private_key" "keypair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "pub_key" {
  key_name   = "keypair"
  public_key = tls_private_key.keypair.public_key_openssh
}

resource "local_file" "keypair-file" {
  filename        = "${aws_key_pair.pub_key.key_name}.pem"
  content         = tls_private_key.keypair.private_key_pem
  file_permission = "600"
}

# use data source to get a registered ubuntu ami
data "aws_ami" "k8s-dev" {

  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

# launch the instance for worker-node1
resource "aws_instance" "jenkins-controller" {
  ami                         = "ami-035cecbff25e0d91e"
  instance_type               = "t2.medium"
  subnet_id                   = aws_default_subnet.az1.id
  vpc_security_group_ids      = [aws_security_group.k8s-sg.id]
  key_name                    = aws_key_pair.pub_key.key_name
  user_data                   = local.jenkins_user_data
  user_data_replace_on_change = true

  tags = {
    Name = "jenkins-controller"
  }
}

# launch the instance for worker-node1
resource "aws_instance" "jenkins-agent" {
  ami                         = "ami-035cecbff25e0d91e"
  instance_type               = "t2.micro"
  subnet_id                   = aws_default_subnet.az1.id
  vpc_security_group_ids      = [aws_security_group.k8s-sg.id]
  key_name                    = aws_key_pair.pub_key.key_name
  user_data                   = local.jenkins_user_data2
  user_data_replace_on_change = true

  tags = {
    Name = "jenkins-agent"
  }
}

# launch the instance for ansible
resource "aws_instance" "ansible" {
  ami                    = data.aws_ami.k8s-dev.id
  instance_type          = "t2.micro"
  subnet_id              = aws_default_subnet.az1.id
  vpc_security_group_ids = [aws_security_group.k8s-sg.id]
  key_name               = aws_key_pair.pub_key.key_name
  # user_data              = file("./ansible/ansible-user-data.sh")
  user_data              = templatefile("./ansible/ansible-user-data.sh", {
    prv-key = tls_private_key.keypair.private_key_pem
    ansible-target-ip = aws_instance.jenkins-agent.public_ip
  })

  user_data_replace_on_change = true

  tags = {
    Name = "ansible"
  }
}



  # user_data = templatefile("./ansible/ansible-user-data.sh", {
  #   keypair = tls_private_key.keypair.private_key_pem
  # templatefile("./ansible/ansible-user-data.sh", {})

# launch the instance for sonarqube
# resource "aws_instance" "sonarqube" {
#   ami                    = data.aws_ami.k8s-dev.id
#   instance_type          = "t2.medium"
#   subnet_id              = aws_default_subnet.az1.id
#   vpc_security_group_ids = [aws_security_group.k8s-sg.id]
#   key_name               = aws_key_pair.pub_key.key_name
#   user_data              = local.sonarqube_user_data

#   tags = {
#     Name = "sonarqube"
#   }
# }

# launch the instance for worker-node1
# resource "aws_instance" "ec2-instance" {
#   ami                    = data.aws_ami.k8s-dev.id
#   instance_type          = "t2.medium"
#   subnet_id              = aws_default_subnet.az1.id
#   vpc_security_group_ids = [aws_security_group.k8s-sg.id]
#   key_name               = aws_key_pair.pub_key.key_name

#   tags = {
#     Name = "ec2-instance"
#   }
# }

# # launch the instance for master node/control plane
# resource "aws_instance" "master-node" {
#   ami                    = data.aws_ami.k8s-dev.id
#   instance_type          = "t2.medium"
#   subnet_id              = aws_default_subnet.az1.id
#   vpc_security_group_ids = [aws_security_group.k8s-sg.id]
#   key_name               = aws_key_pair.pub_key.key_name
#   user_data              = local.master-node_user_data

#   tags = {
#     Name = "master-node"
#   }
# }

# # launch the instance for worker-node1
# resource "aws_instance" "worker-node1" {
#   ami                    = data.aws_ami.k8s-dev.id
#   instance_type          = "t2.micro"
#   subnet_id              = aws_default_subnet.az1.id
#   vpc_security_group_ids = [aws_security_group.k8s-sg.id]
#   key_name               = aws_key_pair.pub_key.key_name
#   user_data              = local.worker-node1_user_data

#   tags = {
#     Name = "worker-node1"
#   }
# }

# # launch the instance for worker-node2
# resource "aws_instance" "worker-node2" {
#   ami                    = data.aws_ami.k8s-dev.id
#   instance_type          = "t2.micro"
#   subnet_id              = aws_default_subnet.az1.id
#   vpc_security_group_ids = [aws_security_group.k8s-sg.id]
#   key_name               = aws_key_pair.pub_key.key_name
#   user_data              = local.worker-node2_user_data

#   tags = {
#     Name = "worker-2"
#   }
# }

# # launch the instance for nfs-server
# resource "aws_instance" "nfs-server" {
#   ami                    = data.aws_ami.k8s-dev.id
#   instance_type          = "t2.micro"
#   subnet_id              = aws_default_subnet.az1.id
#   vpc_security_group_ids = [aws_security_group.k8s-sg.id]
#   key_name               = aws_key_pair.pub_key.key_name
#   user_data              = local.nfs-server_user_data

#   tags = {
#     Name = "nfs-server"
#   }
# }