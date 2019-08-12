provider "aws" {
  region  = "eu-west-2"
  profile = "logging"
}

# Create S3 bucket
resource "aws_s3_bucket" "backend" {
  bucket = "${var.bucket_name}"
  acl    = "private"

  tags = {
    Name = "Terraform State Bucket"
    Env  = "Prod"
  }
}

# Create dynamodb table for the Lock ID
resource "aws_dynamodb_table" "backend" {
  name           = "${var.table_name}"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "Terraform State Table"
    Env  = "Prod"
  }
}
