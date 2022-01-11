module "ec2_dev" {
    source = "../modules"
    instance_type = "t2.nano"
    ami = "ami-04505e74c0741db8d"
    key_name      = "renaud-kp-ajc"
    tag_name = "renaud-ec2-dev"
    tag_formation = "Frazer"
    tag_iac = "terraform"
    environment = "dev"
}