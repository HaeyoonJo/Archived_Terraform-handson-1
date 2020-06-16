# vpc
resource "aws_vpc" "default" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "vpc-${var.vpc_name}"
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

# igw
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "igw-${var.vpc_name}"
  }
}

/*

# rtb : it seems same function as the following: aws_default_route_table
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

*/
resource "aws_default_route_table" "route_table" {
  default_route_table_id = aws_vpc.default.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }
  tags = {
    Name = "default route table"
  }
}



# association with subnet and route table
resource "aws_route_table_association" "subnet" {
  count          = length(var.availability_zones)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_default_route_table.route_table.id
}

# security_group
resource "aws_security_group" "allow_sg" {
  name        = "allow_sg"
  description = "sg traffic"
  vpc_id      = aws_vpc.default.id

  ingress {
    description = "web"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ip_addr]
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
