variable "s3_bucket" {
  type = string
}
variable "s3_key" {
  type        = string
  description = "Name of the zip file"
}

variable "timeout" {
  type    = number
  default = 180
}

variable "memory_size" {
  type    = number
  default = 512
}

variable "function_name" {
  type = string
}

variable "permissions" {
  description = "Add aditional permissions to the lambda function"
  default     = []
}

variable "env_variables" {
  default = []
}

variable "handler" {
  type    = string
  default = "lambda_function.lambda_handler"
}

variable "runtime" {
  type    = string
  default = "python3.9"
}

variable "role_arn" {
  type = string
}