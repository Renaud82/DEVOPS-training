resource "aws_instance" "renaud-ec2-wordpress" {
  ami           = "ami-04505e74c0741db8d"
  instance_type = "t3.medium"
  key_name      = "renaud-kp-ajc"
  tags = {
    Name      = "renaud-ec2-wordpress"
    formation = "Frazer"
    iac       = "terraform"
  }
  vpc_security_group_ids = [aws_security_group.sg-renaud.id]


  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get curl -y",
      "curl -fsSL https://get.docker.com -o get-docker.sh",
      "sh get-docker.sh",
      "sudo usermod -aG docker ubuntu",
      "sudo systemctl start docker",
      "sudo docker network create wordpress",
      "sudo docker run --name mysql --network wordpress -e MYSQL_ROOT_PASSWORD=password -e MYSQL_USER=ubuntu -e MYSQL_PASSWORD=ubuntu -e MYSQL_DATABASE=db -d mysql",
      "sudo docker run --name wordpress --network wordpress -e WORDPRESS_DB_HOST=mysql -e WORDPRESS_DB_USER=ubuntu -e WORDPRESS_DB_PASSWORD=ubuntu -e WORDPRESS_DB_NAME=db -d -p 8600:80 wordpress"
    ]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("/Users/renaudsautour/Downloads/DEVOPS/renaud-kp-ajc.pem")
      host        = self.public_ip
    }
  }
}