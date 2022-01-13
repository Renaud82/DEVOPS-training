provider "aws" {
  region     = "us-east-1"
  access_key = "XXXX"
  secret_key = "XXXX"
}

resource "aws_instance" "renaud-ec2" {
  ami           = data.aws_ami.recent_ami.id
  instance_type = var.instancetype
  key_name      = "renaud-kp-ajc"
  vpc_security_group_ids = [aws_security_group.sg.id]
  tags = {
    Name      = "renaud-ec2-terraform"
    formation = "Frazer"
    iac       = "terraform"
  }
}

resource "aws_security_group" "sg" {
  name        = "renaud-sg-terraform"
  description = "Allow some port"

  ingress {
    description      = "TLS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTML"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "renaud_sg_terraform"
  }
}
