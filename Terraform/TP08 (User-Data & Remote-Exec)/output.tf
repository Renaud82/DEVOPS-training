resource "local_file" "file" {
  filename = "/Users/renaudsautour/Downloads/DEVOPS/Terraform/TP8/infos_EC2.txt"
  content  = "IP public: ${aws_instance.renaud-ec2.public_ip} , Id zone de disponibilité: ${aws_instance.renaud-ec2.availability_zone}"
}