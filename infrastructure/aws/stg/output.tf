output "lambda_bucket_name" {
  value = module.my_bucket.bucket_name
}
output "aws_region" {
  value = local.region
}