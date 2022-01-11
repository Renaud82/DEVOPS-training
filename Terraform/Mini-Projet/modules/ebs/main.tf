resource "aws_ebs_volume" "myebs" {
  availability_zone = "${var.ebs_zone}"
  size              = var.ebs_size

  tags = {
    Name = "${var.ebs_tag_name}"
    formation = "${var.ebs_tag_formation}"
  }
}