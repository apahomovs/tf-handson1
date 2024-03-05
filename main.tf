#create vpc:
resource "aws_vpc" "vpc_id" {
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "handson_1"
  }
}

#create 2 public subnets:

resource "aws_subnet" "public_1a" {
  vpc_id                  = aws_vpc.vpc_id.id
  cidr_block              = "10.0.0.0/26"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_1a"
  }
}

resource "aws_subnet" "public_1b" {
  vpc_id                  = aws_vpc.vpc_id.id
  cidr_block              = "10.0.0.64/26"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_1b"
  }
}

#create 2 private subnets: 

resource "aws_subnet" "private_1a" {
  vpc_id                  = aws_vpc.vpc_id.id
  cidr_block              = "10.0.0.128/26"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "private_1a"
  }
}
resource "aws_subnet" "private_1b" {
  vpc_id                  = aws_vpc.vpc_id.id
  cidr_block              = "10.0.0.192/26"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false
  tags = {
    Name = "private_1b"
  }
}

#create igw:
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_id.id

  tags = {
    Name = "handson1"
  }
}

#nat gw:

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_1a.id
  depends_on    = [aws_internet_gateway.igw]
  tags = {
    Name = "handson1"
  }
}

#eip:

resource "aws_eip" "eip" {
  domain = "vpc"
  tags = {
    Name = "handson1"
  }
}

#public route table:

resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.vpc_id.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

#public rt associatinon:
resource "aws_route_table_association" "public_1a_assoc" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.pub_rt.id
}

resource "aws_route_table_association" "public_1b_assoc" {
  subnet_id      = aws_subnet.public_1b.id
  route_table_id = aws_route_table.pub_rt.id
}


#private route table:
resource "aws_route_table" "priv_rt" {
  vpc_id = aws_vpc.vpc_id.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }
}


#private rt associatinon:

resource "aws_route_table_association" "private_1a_assoc" {
  subnet_id      = aws_subnet.private_1a.id
  route_table_id = aws_route_table.priv_rt.id
}

resource "aws_route_table_association" "private_1b_assoc" {
  subnet_id      = aws_subnet.private_1b.id
  route_table_id = aws_route_table.priv_rt.id
}

#create sec group:

resource "aws_security_group" "sgrp_handson1" {
  name        = "handson1_sgrp"
  description = "Allow SSH and HTTP inbound traffic"
  vpc_id      = aws_vpc.vpc_id.id

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
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#create ec2 instance:

resource "aws_instance" "handson_1a_ec2" {
  instance_type        = "t2.micro"
  ami                  = "ami-07761f3ae34c4478d" # Example AMI ID, replace with appropriate one
  subnet_id            = aws_subnet.public_1a.id
  key_name             = "tentek" # Specify your key pair name
  vpc_security_group_ids = [aws_security_group.sgrp_handson1.id] # Use security group ID instead of name

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              EOF
}

resource "aws_instance" "handson_1b_ec2" {
  instance_type   = "t2.micro"
  ami = "ami-07761f3ae34c4478d"
  subnet_id       = aws_subnet.public_1b.id
  key_name        = "tentek"
  security_groups = [aws_security_group.sgrp_handson1.id]
  user_data       = <<-EOF
                              #!/bin/bash
                              yum update -y
                              yum install -y httpd
                              systemctl start httpd
                              systemctl enable httpd
                            EOF
}