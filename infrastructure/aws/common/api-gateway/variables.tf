variable "lambda_function_name" {
  type = string
}

variable "lambda_function_arn" {
  type = string
}

variable "repo" {
  type = string
}

variable "stage" {
  type = string
}

variable "path_part" {
  type    = string
  default = "{proxy+}"
}

variable "api_key_required" {
  type    = bool
  default = false
}
