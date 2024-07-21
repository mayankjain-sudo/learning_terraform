variable "vpc_cidr" {
    description = "The CIDR block for the VPC."
    default = "10.0.0.0/16"
}
variable "pub_subnet1_cidr" {
    description = "The CIDR block for the subnet."
    default = "10.0.1.0/24"
}
variable "pub_subnet2_cidr" {
    description = "The CIDR block for the subnet."
    default = "10.0.2.0/24"
}

variable "availability_zones" {
  type = list(string)
  default = ["ap-south-1a", "ap-south-1b"]
}
