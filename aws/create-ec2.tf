provider "aws" {
  profile    = "default"
  region     = "ap-south-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0d2692b6acea72ee6"
  instance_type = "t2.micro"
}
