resource "aws_api_gateway_rest_api" "my_api_gateway" {
  name        = var.apigateway_name
  description = var.apigateway_description
}
resource "aws_api_gateway_resource" "my_api_gateway_resource" {
  rest_api_id = aws_api_gateway_rest_api.my_api_gateway.id
  parent_id   = aws_api_gateway_rest_api.my_api_gateway.root_resource_id
  path_part   = "{proxy+}"
}
resource "aws_api_gateway_method" "my_api_gateway_method" {
  rest_api_id   = aws_api_gateway_rest_api.my_api_gateway.id
  resource_id   = aws_api_gateway_resource.my_api_gateway_resource.id
  http_method   = "ANY"
  authorization = "NONE"
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
  rest_api_id       = aws_api_gateway_rest_api.my_api_gateway.id
  stage_name        = var.stage
}