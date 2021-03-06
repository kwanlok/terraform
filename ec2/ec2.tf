provider "aws" {
  region     = "ap-east-1"
  access_key = var.accesskey
  secret_key = var.secretkey
}

data "aws_ami" "amzn2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "myec2" {
  ami                    = data.aws_ami.amzn2.id
  instance_type          = var.instance_type
  subnet_id              = var.subnetid
  vpc_security_group_ids = [aws_security_group.internet.id, aws_security_group.ssh.id]
  key_name               = "terraform"

  provisioner "remote-exec" {
    inline = [
      "sudo yum -y update",
      "sudo apt-get install unzip -y",
      "curl 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' -o 'awscliv2.zip' ",
      "unzip awscliv2.zip",
      "sudo ./aws/install",
      "aws --version"
    ]

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ec2-user"
      private_key = file("./terraform.pem")
    }
  }
}

resource "aws_eip" "eip" {
  vpc = true
}

resource "aws_eip_association" "eipasso" {
  instance_id   = aws_instance.myec2.id
  allocation_id = aws_eip.eip.id
}

resource "aws_security_group" "internet" {
  name        = "internet_access"
  description = "Internet access"
  vpc_id      = var.vpc_id

  dynamic "egress" {
    for_each = var.egress_sg_ports
    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

resource "aws_security_group" "ssh" {
  name        = "ssh_access"
  description = "SSH access"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/32"]
  }
}

output "eip" {
  value = aws_eip.eip.public_ip
}