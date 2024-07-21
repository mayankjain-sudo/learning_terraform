variable "ami_id" {
    type = string
    description = "Provide your AMI ID"
}

variable "default_instance_type" {
    type = string
    description = "Provide the default instance type"
}

variable "instance_type" {
    description = "Instance type on the basis of environment"
    type = map(string)
    
    default = {
      "dev" = "t2.micro"
      "uat" = "t2.medium"
      "prod" = "t2.large"
      }
}
