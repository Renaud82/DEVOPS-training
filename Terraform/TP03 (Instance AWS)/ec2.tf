provider "aws" {
    region = "us-east-1"
    access_key = "AKIAXXXNTM5FPKFMG7AV"
    secret_key = "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"
}

resource "aws_instance" "renaud-ec2" {
    ami = "ami-04505e74c0741db8d"
    instance_type = "t2.micro"
    key_name = "renaud-kp-ajc"
    tags = {
        Name = "renaud-ec2-terraform"
        formation = "Frazer"
        iac = "terraform"
    }
}





