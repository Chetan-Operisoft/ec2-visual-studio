terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.46.0"
    }
  }
}

#connect a region
provider "aws" {
    region = "ap-south-1"
}


# Genrate Aws key pair 
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "genrate_key" {
  key_name   = "test"
  public_key = tls_private_key.example.public_key_openssh 
} 

# aws vpc create 
resource "aws_vpc" "vpc1" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

}

# create aws vpc subnet1 
resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = "true"
}

# create aws vpc subnet2 
resource "aws_subnet" "subnet2" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-south-1b"
}

# create internet gateway in vpc 
resource "aws_internet_gateway" "vpc1_igw" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = "vpcigw"
  }
}


# create a route table public 
resource "aws_route_table" "Public_RT" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc1_igw.id
  }

  tags = {
    Name = "default_route_table_association"
  }
}

# associate subnet1 with Public_RT table
resource "aws_route_table_association" "subnet1_ass" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.Public_RT.id
}

# create aws security group for instance 
resource "aws_security_group" "surksha" {
  name        = "surksha"
  description = "aws kii surksha"
  vpc_id      = aws_vpc.vpc1.id

  ingress {
    description      = "ALL Traffic "
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "surksha"
  }
}

# aws instace create 
resource "aws_instance" "ins1" {
  ami                       = var.instance_ami
  instance_type             = var.instance_type
  key_name                  = aws_key_pair.genrate_key.key_name
  associate_public_ip_address = "true"
  vpc_security_group_ids = [ aws_security_group.surksha.id ]
  subnet_id = aws_subnet.subnet1.id

  user_data = <<EOF
    #!/bin/bash
    yum install httpd -y 
    echo "Running script based web" >> /var/www/html/index.html
    systemctl start httpd 
    systemctl enable httpd 
  EOF
}




