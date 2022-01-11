provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAXXXNTM5FPKFMG7AV"
  secret_key = "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"
}

resource "aws_instance" "renaud-ec2" {
  ami           = var.ami_id
  instance_type = var.instancetype
  key_name      = "renaud-kp-ajc"
  tags = {
    Name      = "renaud-ec2-terraform-var"
    formation = "Frazer"
    iac       = "terraform"
  }
}





