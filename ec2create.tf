locals {
  ports = [80, 443, 3389, 22, 8080, 3306]
}


resource "aws_vpc" "myVPC" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "myvpc"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myVPC.id

  tags = {
    Name = "igw"
  }
}
resource "aws_subnet" "mysubnet" {
  vpc_id     = aws_vpc.myVPC.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "subnet"
  }
}
resource "aws_route_table" "myrt" {
  vpc_id = aws_vpc.myVPC.id

  route = []
  tags = {
    Name = "example"
  }
}
resource "aws_route" "r" {
  route_table_id         = aws_route_table.myrt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
  depends_on             = [aws_route_table.myrt]
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.mysubnet.id
  route_table_id = aws_route_table.myrt.id
}

resource "aws_security_group" "sg" {
  name        = "allow_all_traffic"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.myVPC.id

  dynamic "ingress" {
    for_each = local.ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}
variable "instance_type" {
  type = string
}

variable "instance_count" {
  type    = number
  default = 1
}
variable "environment_decision" {
  default = "prod"
}
resource "aws_instance" "myec2" {
  ami           = "ami-05fa00d4c63e32376"
  instance_type = var.instance_type
  subnet_id     = aws_subnet.mysubnet.id
  count         = "${var.environment_decision != "prod" ? 2 : 1}"
  tags = {
    Name = "HelloWorld-${count.index + 1}"

  }
}