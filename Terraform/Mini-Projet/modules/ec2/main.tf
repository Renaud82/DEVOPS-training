resource "aws_instance" "myec2" {
  ami           = "${var.ec2_ami}"
  instance_type = "${var.ec2_instance_type}"
  key_name      = "${var.ec2_key_name}"
  tags = {
    Name      = "${var.ec2_tag_name}"
    formation = "${var.ec2_tag_formation}"
    iac       = "terraform"
  }

  vpc_security_group_ids = [var.sg_id]

  user_data              = <<-EOF
             y #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install nginx -y
              sudo systemctl enable nginx
              sudo systemctl start nginx
              EOF
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.myec2.id
  allocation_id = var.eip_id
}