resource "aws_instance" "renaud-ec2-remote" {
  ami           = "ami-04505e74c0741db8d"
  instance_type = "t2.micro"
  key_name      = "renaud-kp-ajc"
  tags = {
    Name      = "renaud-ec2-nginx-remote"
    formation = "Frazer"
    iac       = "terraform"
  }
  vpc_security_group_ids = [aws_security_group.sg-nginx.id]

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install nginx -y",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx"
    ]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("/Users/renaudsautour/Downloads/DEVOPS/renaud-kp-ajc.pem")
      host        = self.public_ip
    }
  }

  provisioner "local-exec" {
    command = "echo '${self.tags.Name} [PUBLIC IP : ${self.public_ip} , ID: ${self.id} , AZ: ${self.availability_zone}]' >> infos-ec2-remote.txt"
  }
}