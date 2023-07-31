output "bucket_name" {
    value = resource.aws_s3_bucket.my_bucket.bucket
}

output "bucket_arn" {
    value = resource.aws_s3_bucket.my_bucket.arn
}