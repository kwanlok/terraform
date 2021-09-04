provider "aws" {
  region = "ap-east-1"
  access_key = var.accesskey
  secret_key = var.secretkey
}

resource "aws_instance" "myec2" {
    ami = var.ami
    instance_type = var.instance_type
    subnet_id = var.subnetid
}