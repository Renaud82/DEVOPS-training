output "ec2_id" {
    value = aws_instance.myec2.id
}

output "ec2_public_ip" {
    value = aws_instance.myec2.public_ip
}

output "ec2_availability_zone" {
    value = aws_instance.myec2.availability_zone
}

