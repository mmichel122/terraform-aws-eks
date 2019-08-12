output "bucket_arn" {
  value = "${aws_s3_bucket.backend.arn}"
}

output "dynamodb_lock_table_arn" {
  value = "${aws_dynamodb_table.backend.arn}"
}
