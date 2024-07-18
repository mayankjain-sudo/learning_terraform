provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_instance" "example" {
  instance_type = "t2.micro"
  ami = "ami-0ad21ae1d0696ad58"
  subnet_id = "subnet-01ebb3399b7ed94e5"
}

resource "aws_s3_bucket" "tfstatefile" {  #To staore the state file in S3 bucket we are creating a bucket.
  bucket = "mayankjaine_learning"
}

resource "aws_dynamodb_table" "terraform_lock" { #creating a Dynomo db table to hold the state file.
    name = "terraform_lock"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"
    attribute {
      name = "LockID"
      type = "S"
    }
}

