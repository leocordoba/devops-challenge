provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

resource "aws_vpc" "main" {
  cidr_block = "10.1.0.0/16"
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group" "prod_web" {
  name        = "prod_web"
  description = "Allow only SSH"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Terraform" : "true"
  }
}

resource "aws_eip" "prod_web" {
  instance   = aws_instance.prod_web.id
  vpc        = true
  tags = {
    "Terraform" : "true"
  }
}

resource "aws_key_pair" "default" {
  key_name   = "ssh_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC5UtFfIMIUqSKEi/vJgpCMLi7bkK2r7F5OTK9Ri5bum6EGXOQYwfLPtNnj3l+8ZwLYGwujvfotMonZXQ4vY3wJJJQi9S/Ha3mbqR4NTyHiJjyl4spPWmvV9FyG21aR/IhJU0VIo6KlOiZjCRWjR2uwxT9CLPqLi6OLJri1nBTF4t1x/GqFhvHOyMiLgwc8chUWyPkF2HUAO8O7GKEjnSZVGTIY/RD/N6bOSkuG4SXK7+qbgtAY08yOBmItj+0amvHsvHB25L0JUs3YRE78rZO7VX1VObugU7D8C8ThWZryXaxuFuEL4+iJbmepqkqzTSXzjmECpnRRRw1u2ornoO4izWyZaGHZrtRWbdH/OZL/Z0WBweKgCo4jVKVh52InO0BkODDXThfl51/4W8tCSN1ZI8N2z7i3woHq1QA6+AZTNi0d+4UHOla2CDRhFzBi48f5ii6cs0wRCkdFGhRN9Y+/APyCQr9rEQE+aYKo0BUJnwEUk7SQOHpInYv6eLqyXoc= jleon@DESKTOP-EQM2L03"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


resource "aws_instance" "prod_web" {
  ami	        = data.aws_ami.ubuntu.id
  instance_type = "t2.nano"
  key_name      = aws_key_pair.default.key_name
  
  vpc_security_group_ids = [
    aws_security_group.prod_web.id
  ]

  tags = {
    "Terraform" : "true"
  }
}

output "public_ip" {
  value = aws_eip.prod_web.public_ip
}

