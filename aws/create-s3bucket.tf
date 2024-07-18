resource "aws_s3_bucket" "mybucket" {
    name = "mytestbucket123"
    tags = {
      "Description" = "Creating sample bucket"
    }
}

//upload data in s3 bucket
resource "aws_s3_bucket_object" "mybucketupload" {
    content = "aws/admin-policy.json"
    key = "admin-policy.json"
    bucket = aws_s3_bucket.mybucket.id
  
}