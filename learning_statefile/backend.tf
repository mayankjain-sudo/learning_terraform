terraform {
  backend "s3" {
    bucket = "mybucket"
    key    = "mayankjaine_learning/terraform.tfstate"   # Any prefix to the folder
    region = "ap-southeast-1"
    dynamodb_table = "terraform_lock"  #table name which hold the lock
  }
}
