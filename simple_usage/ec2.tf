
# EC2 Instance creeation
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = "naver-docker"
  #### if i wanna create ec2 instances in each subnet  ####
  subnet_id              = aws_subnet.public_subnet[1].id
  vpc_security_group_ids = [aws_security_group.allow_sg.id]

  tags = {
    Name = "instance-${var.vpc_name}"
  }
}
