data "aws_ami" "recent_ami" {
    most_recent =  true
    owners = ["amazon"]

  filter {
    name   = "name"
    values = ["Deep Learning AMI (Amazon Li*"]
  }
}