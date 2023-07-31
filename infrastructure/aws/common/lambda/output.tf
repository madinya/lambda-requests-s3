output "invoke_arn" {
  value = resource.aws_lambda_function.my_lambda.invoke_arn
}