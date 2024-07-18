# This file is use for calling the modules 

provider "aws" {
  region = "ap-southeast-1"
}

module "ec2_instance" {
  source = "./modules/ec2_instance"
  ami_value= var.ami_value
  instance_type_value=var.instance_type_value
  key_name_value=var.key_name_value
  subnet_id_value=var.subnet_id_value
}

# Below is alternate way for writing module.
#module "ec2_instance" {
#  source = "./modules/ec2_instance"
#  ami_value= "AMI ID "
#  instance_type_value="Intance Type"
#  key_name_value="Key Name"
#  subnet_id_value="Subnet ID"
#}