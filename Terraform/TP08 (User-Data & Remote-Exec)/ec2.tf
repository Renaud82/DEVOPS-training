resource "aws_instance" "renaud-ec2" {
  ami           = "ami-04505e74c0741db8d"
  instance_type = "t2.micro"
  key_name      = "renaud-kp-ajc"
  tags = {
    Name      = "renaud-ec2-nginx"
    formation = "Frazer"
    iac       = "terraform"
  }
  vpc_security_group_ids = [aws_security_group.sg-nginx.id]
  user_data              = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install nginx -y
              sudo systemctl enable nginx
              sudo systemctl start nginx
              EOF
}