variable "accesskey" {
  type = string
  default = ""
}

variable "secretkey" {
  type = string
  default = ""
}

variable "subnetid" {
  type = string
  default = ""
}

variable "instance_type" {
  type = string
  default = "t3.micro"
}

variable "vpc_id" {
  type = string
  default = ""
}

variable "my_ip" {
  type = string
  default = ""
}

variable "egress_sg_ports" {
  type        = list(number)
  description = "list of egress ports"
  default     = [80,443]
}