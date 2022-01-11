resource "aws_instance" "myec2" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name      = "${var.key_name}"
  tags = {
    Name      = "${var.tag_name}"
    formation = "${var.tag_formation}"
    iac       = "${var.tag_iac}"
  }
  vpc_security_group_ids = [aws_security_group.mysg.id]
}

resource "local_file" "file" {
    filename="/Users/renaudsautour/Downloads/DEVOPS/Terraform/TP10/${var.tag_name}_parameter.txt"
    content="Pour cet EC2, nous avons utilisé le type d’instance ${aws_instance.myec2.instance_type} et l’image ${aws_instance.myec2.ami} où instance_type et ami sont les attributs de la ressource ec2 précédemment crée."
}

resource "aws_eip" "mylb" {
  vpc = true
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.myec2.id
  allocation_id = aws_eip.mylb.id
}