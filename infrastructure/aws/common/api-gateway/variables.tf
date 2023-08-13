variable "lambda_function_name" {
  type = string
}

variable "lambda_function_arn" {
  type = string
}

variable "apigateway_name" {
  type = string
}

variable "apigateway_description" {
  type    = string
  default = "by MAD"
}

variable "stage" {
    type = string
}