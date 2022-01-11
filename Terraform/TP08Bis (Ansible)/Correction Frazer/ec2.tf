resource "aws_instance" "frazer-ec2" {
  ami             = data.aws_ami.my-ami.id
  key_name        = "frazer-kp-ajc1"
  instance_type   = "${var.instance_type}"
  security_groups = ["${aws_security_group.my_sg.name}", "frazer-sg-web"]
  user_data       = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get -y install nginx
              sudo systemctl enable nginx
              sudo systemctl start nginx
              EOF
  tags = {
    Name = "${var.admin}-ec2"
    iac  = "terraform"
  }

  provisioner "local-exec" {
    command = "echo '${aws_instance.frazer-ec2.tags.Name} [PUBLIC IP : ${self.public_ip} , ID: ${self.id} , AZ: ${self.availability_zone}]' >> infos-ec2.txt"
  }
}

resource "aws_instance" "ajc-ec2" {
  ami             = data.aws_ami.my-ami.id
  key_name        = "frazer-kp-ajc1"
  instance_type   = "${var.instance_type}"
  security_groups = ["${aws_security_group.my_sg.name}", "frazer-sg-web"]
  tags = {
    Name = "${var.admin}-ec2-ajc"
    iac  = "terraform"
  }

  provisioner "local-exec" {
    command = "echo '${self.tags.Name} [PUBLIC IP : ${self.public_ip} , ID: ${self.id} , AZ: ${self.availability_zone}]' >> infos-ec2.txt"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get -y install ansible git",
      "git clone https://github.com/sadofrazer/deploy_wordpress.git",
      "cd deploy_wordpress",
      "ansible-galaxy install -r roles/requirements.yml",
      "ansible-playbook -i hosts.yml wordpress.yml -e wp_port=${var.port}"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("/Users/sadofrazer/Données/DevOps/AWS/.aws/frazer-kp-ajc1.pem")
      host        = self.public_ip
    }
  }
}

data "aws_ami" "my-ami" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

data "local_file" "file1" {
  filename = "/Users/sadofrazer/Données/DevOps/TERRAFORM/terraform_training/AJC/TP-7/infos.txt"
}

resource "aws_security_group" "my_sg" {
  name        = "${var.admin}-sg"
  description = "Allow  inbound traffic with ports 80 & 443"
  #vpc_id      = aws_vpc.main.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.admin}-sg"
  }
}