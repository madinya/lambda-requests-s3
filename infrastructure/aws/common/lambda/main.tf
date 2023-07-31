resource "aws_lambda_function" "my_lambda" {
  s3_bucket     = var.s3_bucket
  s3_key        = var.s3_key
  function_name = var.function_name
  role          = var.role_arn
  timeout       = var.timeout
  memory_size   = var.memory_size
  handler       = var.handler
  runtime       = var.runtime
  dynamic "environment" {
    for_each = var.env_variables
    content {
      variables = environment.value
    }
  }
}

