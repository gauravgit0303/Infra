
resource "aws_vpc" "myVPC" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "myvpc"
  }
}
resource "aws_subnet" "mysubnet" {
  vpc_id     = aws_vpc.myVPC.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "subnet"
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
  tags = {
    Name = "HelloWorld1"
  }
}