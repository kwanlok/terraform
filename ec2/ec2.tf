provider "aws" {
  region = "ap-east-1"
  access_key = var.accesskey
  secret_key = var.secretkey
}

resource "aws_instance" "myec2" {
    ami = var.ami
    instance_type = var.instance_type
    subnet_id = var.subnetid
    vpc_security_group_ids = [aws_security_group.internet.id, aws_security_group.ssh.id]
}

resource "aws_eip" "eip"{
  vpc = true
}

resource "aws_eip_association" "eipasso" {
  instance_id = aws_instance.myec2.id
  allocation_id = aws_eip.eip.id
}

resource "aws_security_group" "internet" {
  name = "internet_access"
  description = "Internet access"
  vpc_id = var.vpc_id
  egress {
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  egress {
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "ssh" {
  name = "ssh_access"
  description = "SSH access"
  vpc_id = var.vpc_id
  ingress {
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["${var.my_ip}/32"]
    }
}

output "eip" {
  value = aws_eip.eip.public_ip
}