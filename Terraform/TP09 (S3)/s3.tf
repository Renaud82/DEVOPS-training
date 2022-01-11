terraform {
    backend "s3" {
        bucket = "renaud-bucket-ajc"
        key = "ec2.tfstate"
        region = "us-east-1"
        shared_credentials_file = "/Users/renaudsautour/Downloads/DEVOPS/Terraform/credentials"
    }
}