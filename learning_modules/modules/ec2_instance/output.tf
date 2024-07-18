output "public_ip" {
    value = aws_instance.example.public_ip
}
output "instance_size" {
    value = aws_instance.example.instance_type
}
output "instance_subnet" {
    value = aws_instance.example.subnet_id
}
output "instance_key_name" {
    value = aws_instance.example.key_name
}