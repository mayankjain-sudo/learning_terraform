variable "vpc_cidr_value" {
    type = string
    description = "Enter the VPC cird value example 10.0.0.0/16"
}
variable "subnet_cidr_value" {
    type = string
    description = "Enter subnet cidr value"
}
variable "availability_zone_value" {
    type = string
    description = "Enter availability zone"
}
variable "keypair_name_value" {
    type = string
    description = "Enter the keypair name"
}
variable "pubkey_path_value" {
    type = string
    description = "Enter the path of the public key"
}
variable "private_key_value" {
    type = string
    description = "Enter the path of the private key"
}
variable "ami_id_value" {
    type = string
    description = "Enter the ami id value"
}
variable "security_group_name_value" {
    type = string
    description = "Enter the security group name"
}
variable "instance_type_value" {
    type = string
    description = "Enter the instance type"
}
variable "instance_name_value" {
    type = string
    description = "Enter the instance name"
}