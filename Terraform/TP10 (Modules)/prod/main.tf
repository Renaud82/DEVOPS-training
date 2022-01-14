module "ec2_prod" {
    source        = "../modules"
    instance_type = "t2.micro"
    ami           = "ami-04505e74c0741db8d"
    key_name      = "renaud-kp-ajc"
    tag_name      = "renaud-ec2-prod"
    tag_formation = "Frazer"
    tag_iac       = "terraform"
    environment   = "prod"
}
