resource "aws_eip" "myeip" {
  vpc = true
  tags = {
    Name = "${var.eip_tag_name}"
    formation = "${var.eip_tag_formation}"
  }
}