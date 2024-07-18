provider "aws" {
    region = "us-east-1"
}

resource "aws_iam_user" "adminUser" {
    name = "admin"
    tags = {
        Description = "Server Admin"
    }
}