output "invoke_url" {
    value = aws_api_gateway_deployment.my_deployment.invoke_url
}

output "execution_arn" {
  value = aws_api_gateway_deployment.my_deployment.execution_arn
}