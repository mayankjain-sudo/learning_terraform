provider "aws" {
    region = "ap-south-1"
}

import {
  id = "i-10675489090hj6358"  # resource ID for which we need to generate terraform 

  to = aws_instance.example  # reource type with name of resource which is required when terraform generated.
}

resource "aws_instance" "example" {
    ami = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"
    tags = {
        Name = "My Instance"
        }
  
}