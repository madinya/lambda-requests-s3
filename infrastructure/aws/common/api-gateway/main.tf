resource "aws_api_gateway_rest_api" "my_api_gateway" {
  name        = "${var.repo}-api-gw-${var.stage}"
  description = "API Gateway for ${var.repo}-api-gw-${var.stage} project"
}
resource "aws_api_gateway_resource" "my_api_gateway_resource" {
  rest_api_id = aws_api_gateway_rest_api.my_api_gateway.id
  parent_id   = aws_api_gateway_rest_api.my_api_gateway.root_resource_id
  path_part   = "{proxy+}"
}
resource "aws_api_gateway_method" "my_api_gateway_method" {
  rest_api_id      = aws_api_gateway_rest_api.my_api_gateway.id
  resource_id      = aws_api_gateway_resource.my_api_gateway_resource.id
  http_method      = "ANY"
  authorization    = "NONE"
  api_key_required = var.api_key_required
}
resource "aws_api_gateway_integration" "my_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.my_api_gateway.id
  resource_id             = aws_api_gateway_method.my_api_gateway_method.resource_id
  http_method             = aws_api_gateway_method.my_api_gateway_method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = var.lambda_function_arn
}
resource "aws_lambda_permission" "allow_execution_from_my_api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
}
resource "aws_api_gateway_deployment" "my_deployment" {
  rest_api_id = aws_api_gateway_rest_api.my_api_gateway.id
  stage_name  = var.stage
}

resource "aws_api_gateway_usage_plan" "usage_plan" {
  name = "${var.repo}-api-gw-up-${var.stage}"
  api_stages {
    api_id = resource.aws_api_gateway_rest_api.my_api_gateway.id
    stage  = var.stage
  }
}

resource "aws_api_gateway_api_key" "api_key" {
  name = "${var.repo}-api-key-${var.stage}"
}

resource "aws_api_gateway_usage_plan_key" "api_key_attachment" {
  key_id        = aws_api_gateway_api_key.api_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.usage_plan.id
}
