provider "aws" {
  version = "~> 3.0"
  region     = "us-east-1"
}

# Create a VPC
resource "aws_vpc" "ndukaterraform" {
  cidr_block = "10.0.0.0/16"
  
    tags = {
    Name = "ndukaterraform"
  }
}
resource "aws_subnet" "pubb" {
  vpc_id     = "${aws_vpc.ndukaterraform.id}"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "pubb"
  }
}
resource "aws_subnet" "pub22" {
  vpc_id     = "${aws_vpc.ndukaterraform.id}"
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "pub22"
  }
}
resource "aws_internet_gateway" "ndukatgGW" {
  vpc_id = "${aws_vpc.ndukaterraform.id}"

  tags = {
    Name = "ndukatgGW"
  }
}
resource "aws_route_table" "ndukaroute" {
  vpc_id = "${aws_vpc.ndukaterraform.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.ndukatgGW.id}"
  }

  tags = {
    Name = "ndukaroute"
  }
}
resource "aws_route_table_association" "ndukaroute" {
  subnet_id      = "${aws_subnet.pubb.id}"
  route_table_id = "${aws_route_table.ndukaroute.id}"
}

resource "aws_security_group" "terra-SG" {
  name        = "terra-SG"
  description = "Allow TLS inbound traffic"
  vpc_id      = "${aws_vpc.ndukaterraform.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    Name = "terra-SG"
  }
}

resource "aws_route_table_association" "ndukaroute1" {
  subnet_id      = "${aws_subnet.pub22.id}"
  route_table_id = "${aws_route_table.ndukaroute.id}"
}
