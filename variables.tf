variable "aws_region" {
  description = "Region for the VPC"
  default = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default = "192.168.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  default = "192.168.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the private subnet"
  default = "192.168.2.0/24"
}

variable "ami" {
  description = "Amazon Linux AMI"
  default = "ami-024a64a6685d05041"
}

variable "key_path" {
  description = "SSH Public Key path"
  default = "~/.ssh/id_rsa.pub"
}

variable "ec2_key_pair_name" {
    description = "EC2 key pair name (.pem file name, Which you can find in your AWS EC2 dashboard under keypairs menu)"
}

variable "enpoint_name" {
    description = "Service name provided by Heroku-ref:https://devcenter.heroku.com/articles/heroku-postgres-via-privatelink#step-4-obtain-your-endpoint-s-service-name"
}