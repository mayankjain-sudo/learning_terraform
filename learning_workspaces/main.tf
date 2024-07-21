provider "aws" {
    region = "ap-south-1"
}

module "ec2_instance" {
    source = "./modules/ec2_instance"
    ami_id = var.ami_id
    instance_type = lookup(var.instance_type, terraform.workspace, var.default_instance_type)
}

