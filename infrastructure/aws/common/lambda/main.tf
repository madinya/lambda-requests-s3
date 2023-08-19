resource "aws_lambda_function" "my_lambda" {
  filename      = var.filename
  function_name = "${var.repo}-fn-${var.stage}"
  role          = var.role_arn
  timeout       = var.timeout
  memory_size   = var.memory_size
  handler       = var.handler
  runtime       = var.runtime
  tags          = { "version" = var.tag, "stage" = var.stage }
  dynamic "environment" {
    for_each = var.env_variables
    content {
      variables = environment.value
    }
  }
}

