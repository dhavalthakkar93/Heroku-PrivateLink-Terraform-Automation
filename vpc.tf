# AWS VPC
resource "aws_vpc" "heroku-privatelink-vpc-101" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags = {
    Name = "heroku-privatelink-vpc-101"
  }
}

# Public Subnet
resource "aws_subnet" "heroku-privatelink-public-subnet" {
  vpc_id = "${aws_vpc.heroku-privatelink-vpc-101.id}"
  cidr_block = "${var.public_subnet_cidr}"
  availability_zone = "us-east-1b"

  tags = {
    Name = "PrivateLink Public Subnet"
  }
}

# Private Subnet
resource "aws_subnet" "heroku-privatelink-private-subnet" {
  vpc_id = "${aws_vpc.heroku-privatelink-vpc-101.id}"
  cidr_block = "${var.private_subnet_cidr}"
  availability_zone = "us-east-1b"

  tags = {
    Name = "PrivateLink Private Subnet"
  }
}

# IGW
resource "aws_internet_gateway" "heroku-privatelink-IGW" {
  vpc_id = "${aws_vpc.heroku-privatelink-vpc-101.id}"

  tags = {
    Name = "PrivateLink VPC IGW"
  }
}

# Route Table
resource "aws_route_table" "privatelink-web-public-rt" {
  vpc_id = "${aws_vpc.heroku-privatelink-vpc-101.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.heroku-privatelink-IGW.id}"
  }

  tags = {
    Name = "Public Subnet RT"
  }
}

# Route table subnet association
resource "aws_route_table_association" "privatelink-web-public-rt" {
  subnet_id = "${aws_subnet.heroku-privatelink-public-subnet.id}"
  route_table_id = "${aws_route_table.privatelink-web-public-rt.id}"
}

# Security Group for Public Subnet
resource "aws_security_group" "privatelink-sgweb" {
  name = "privatelink-vpc-web-sg"
  description = "Allow incoming HTTP connections, SSH access & Postgres access"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 5432
    to_port = 5433
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
  
  vpc_id="${aws_vpc.heroku-privatelink-vpc-101.id}"

  tags = {
    Name = "Private Link Web SG"
  }
}

# VPC Endpoint
resource "aws_vpc_endpoint" "heroku-privatelink" {
    vpc_id       = "${aws_vpc.heroku-privatelink-vpc-101.id}"
    service_name = "${var.enpoint_name}"  
    vpc_endpoint_type = "Interface" 
    subnet_ids = ["${aws_subnet.heroku-privatelink-public-subnet.id}"]
    security_group_ids = [
    "${aws_security_group.privatelink-sgweb.id}",
  ]  
}