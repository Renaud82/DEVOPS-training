provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAXXXNTM5FJWAHW45D"
  secret_key = "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"
}

resource "aws_instance" "renaud-ec2" {
  ami           = var.ami_id
  instance_type = var.instancetype
  key_name      = "renaud-kp-ajc"
  tags = {
    Name      = "renaud-ec2-terraform"
    formation = "Frazer"
    iac       = "terraform"
  }
}

resource "local_file" "file" {
    filename="/Users/renaudsautour/Downloads/DEVOPS/Terraform/TP5/ec2-parameters.txt"
    content="Pour cet EC2, nous avons utilisé le type d’instance ${aws_instance.renaud-ec2.instance_type} et l’image ${aws_instance.renaud-ec2.ami} où instance_type et ami sont les attributs de la ressource ec2 précédemment crée."
}

resource "aws_eip" "ajc-lb" {
  vpc = true
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.renaud-ec2.id
  allocation_id = aws_eip.ajc-lb.id
}