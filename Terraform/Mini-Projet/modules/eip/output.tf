output "eip_id" {
    value = aws_eip.myeip.id
}

output "eip_ip" {
    value = aws_eip.myeip.public_ip
}
