output "lambda_bucket_name" {
  value = module.lambda_code_bucket.bucket_name
}
output "aws_region" {
  value = local.region
}