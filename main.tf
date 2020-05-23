provider "aws" {
  region = var.aws_region
  access_key = var.access_key_id
  secret_key = var.secret_access_key
}



# vpc
resource "aws_vpc" "default" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "vpc-${var.vpc_name}"
  }
}




# igw
resource "aws_internet_gateway" "default"{
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "igw-${var.vpc_name}"
  }
}

# subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = "10.0.${var.cidr_numeral_public[count.index]}.0/20"
  availability_zone       = element(var.availability_zones, count.index)
  count                   = length(var.availability_zones)
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet#${count.index}-${var.vpc_name}"
  }
}

# route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.default.id

  route {
  cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }

  tags = {
    Name = "public-rtb-${var.vpc_name}"
  }
}


resource "aws_route_table_association" "subnet" {
  count          = length(var.availability_zones)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public.id
}


# security_group
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "sg traffic"
  vpc_id      = aws_vpc.default.id

  ingress {
    description = "web server"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh sg"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_addr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-traffic-${var.vpc_name}"
  }
}



# EC2 Instance creeation
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name    = "name"
    values  = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name    = "virtualization-type"
    values  = ["hvm"]
  }
  owners    = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami                     = data.aws_ami.ubuntu.id
  instance_type           = "t2.micro"
  key_name                = "naver-docker"
  subnet_id               = aws_subnet.public_subnet[1].id
  vpc_security_group_ids         = [aws_security_group.allow_tls.id]

  tags = {
    Name                  = "instance-${var.vpc_name}"
  }
}

# Output of Instance public IP
output "public_ip" {
  description = "List of public IP addresses assigned to the instances, if applicable"
  value       = aws_instance.web.*.public_ip
}
