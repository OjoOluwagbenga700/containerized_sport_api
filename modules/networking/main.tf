# create vpc
resource "aws_vpc" "vpc" {
  cidr_block              = var.vpc_cidr
  instance_tenancy        = "default"
  enable_dns_hostnames    = true

  tags      = {
    Name    = "${var.project_name}-vpc"
  }
}

# create internet gateway and attach it to vpc
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id    = aws_vpc.vpc.id

  tags      = {
    Name    = "${var.project_name}-igw"
  }
}

# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}

# create public subnet az1
resource "aws_subnet" "public_subnet1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet1_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names [0]
  map_public_ip_on_launch = true

  tags      = {
    Name    = "public_subnet1"
  }
}

# create public subnet az2
resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet2_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names [1]
  map_public_ip_on_launch = true
 
  tags      = {
    Name    = "public_subnet"
  }
}

# create route table and add public route
resource "aws_route_table" "public_route_table" {
  vpc_id       = aws_vpc.vpc.id

  route {
    cidr_block ="0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags       = {
    Name     = "public_route_table"
  }
}

# associate public subnet az1 to "public route table"
resource "aws_route_table_association" "public_subnet1_route_table_association" {
  subnet_id           = aws_subnet.public_subnet1.id
  route_table_id      = aws_route_table.public_route_table.id
}

# associate public subnet az2 to "public route table"
resource "aws_route_table_association" "public_subnet2_route_table_association" {
  subnet_id           = aws_subnet.public_subnet2.id
  route_table_id      = aws_route_table.public_route_table.id
}

# create private app subnet az1
resource "aws_subnet" "private_subnet1" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.private_subnet1_cidr
  availability_zone        = data.aws_availability_zones.available_zones.names [0]
  map_public_ip_on_launch  = false
  tags      = {
    Name    = "private_subnet1"
  }
}

# create private app subnet az2
resource "aws_subnet" "private_subnet2" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.private_subnet2_cidr
  availability_zone        = data.aws_availability_zones.available_zones.names [1]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "private_subnet2"
  }
}


# Apllication Load Balancer Security Group
resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "enable http/https access on port 80 and 443 respectively"
  vpc_id      = aws_vpc.vpc.id

ingress {
    description      = "http access"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

ingress {
    description      = "https access"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
   egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

tags   = {
    Name = "alb_sg"
  }

 }
resource "aws_security_group" "ecs_sg" {
  name        = "ecs_sg"
  description = "enable  access on port 8080 through alb_sg"
  vpc_id      = aws_vpc.vpc.id


ingress {
    description      = "http access"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    security_groups  = [aws_security_group.alb_sg.id]
  }

   egress {
    from_port        = 0
    to_port          = 0    
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }
tags   = {
    Name = "ecs_sg"
  }
}