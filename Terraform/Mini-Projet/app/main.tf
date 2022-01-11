module "sg_creation" {
    source = "../modules/sg"
    sg_tag_name = "renaud_sg_terraform"
    sg_tag_formation = "Frazer"
}

module "eip_creation" {
    source = "../modules/eip"
    eip_tag_name = "renaud_eip_terraform"
    eip_tag_formation = "Frazer"
}

module "ec2_creation" {
    source = "../modules/ec2"
    ec2_instance_type = "t2.nano"
    ec2_ami = data.aws_ami.myami.id
    ec2_key_name      = "renaud-kp-ajc"
    ec2_tag_name = "renaud-ec2-terraform"
    ec2_tag_formation = "Frazer"
    sg_id = module.sg_creation.sg_id
    eip_id = module.eip_creation.eip_id
}

module "ebs_creation" {
    source = "../modules/ebs"
    ebs_zone = module.ec2_creation.ec2_availability_zone
    ebs_size =  10
    ebs_tag_name = "renaud_ebs_terraform"
    ebs_tag_formation = "Frazer"
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  instance_id   = module.ec2_creation.ec2_id
  volume_id   = module.ebs_creation.ebs_id
}

resource "local_file" "file" {
    filename = "/Users/renaudsautour/Downloads/DEVOPS/Terraform/Mini-Projet/app/ip_ec2.txt"
    content = "EC2 créée avec pour adresse IP Public: ${module.eip_creation.eip_ip}"
}