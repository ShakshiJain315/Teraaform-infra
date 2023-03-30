provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "main" {
  cidr_block       = "172.16.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "main"
  }
}

#Create security group with firewall rules
resource "aws_security_group" "jenkins-sg-2022" {
  name        = var.security_group
  description = "security group for Ec2 instance"
  vpc_id      = aws_vpc.main.id
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound from jenkis server
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.security_group
  }
}
resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "tf-example"
  }
}
resource "aws_instance" "myFirstInstance" {
  ami = var.ami_id
  // vpc_id = aws_vpc.main.id
  key_name               = var.key_name
  subnet_id              = aws_subnet.my_subnet.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.jenkins-sg-2022.id]
  tags = {
    Name = var.tag_name
  }
}

# Create Elastic IP address
//resource "aws_eip" "myFirstInstance" {
 // vpc      = true
  //instance = aws_instance.myFirstInstance.id
  //tags = {
    //Name = "my_elastic_ip"
  //}
//}
