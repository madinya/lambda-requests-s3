output "lambda_bucket_name" {
  value = module.my_bucket.bucket_name
}
output "aws_region" {
  value = local.region
}
output "apigateway_invoke_url" {
  value = module.my_api_gateway.invoke_url
}
