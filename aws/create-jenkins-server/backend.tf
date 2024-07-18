terraform {
  backend "s3" {
    bucket = "mayanklearning-app"
    region = "us-east-1"
    key = "jenkins-server/terraform.tfstate"
  }
}