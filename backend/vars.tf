variable "bucket_name" {
  description = "The name to use for the S3 bucket. Note that S3 bucket names must be globally unique across all AWS users!"
}

variable "aws_region" {
  description = "The AWS region to deploy into (e.g. eu-west-2)."
  default     = "eu-west-2"
}

variable "table_name" {
  description = "The name to use for the DynamoDB table that will be created for Terraform locking"
  default     = "terraform-locks-example"
}
