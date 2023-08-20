
variable "filename" {
  type        = string
  description = "Name of the code zip file"
}

variable "filename_requirements" {
  type        = string
  description = "Name of the requirements zip file"
}

variable "timeout" {
  type    = number
  default = 180
}

variable "memory_size" {
  type    = number
  default = 512
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

variable "repo" {
  type = string
}
variable "stage" {
  type = string
}

variable "source_arn" {
  type = string
}
