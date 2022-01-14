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
      "sudo apt-get -y install ansible git",
      "git clone https://github.com/Renaud82/wordpress_deploy.git",
      "cd wordpress_deploy",
      "ansible-galaxy install -r roles/requirements.yml",
      "ansible-playbook -i hosts.yml wordpress.yml"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("/Users/renaudsautour/Downloads/DEVOPS/renaud-kp-ajc.pem")
      host        = self.public_ip
    }
  }
}
