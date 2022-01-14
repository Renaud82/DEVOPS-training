provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "/Users/renaudsautour/Downloads/DEVOPS/Terraform/credentials"
}

resource "aws_instance" "renaud-ec2" {
  ami           = "ami-04505e74c0741db8d"
  instance_type = data.local_file.file.content
  key_name      = "renaud-kp-ajc"
  tags = {
    Name      = "renaud-ec2-terraform"
    formation = "Frazer"
    iac       = "terraform"
  }
}

data "local_file" "file" {
  filename = "/Users/renaudsautour/Downloads/DEVOPS/Terraform/TP6/info.txt"
}
