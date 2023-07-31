variable "role_name" {
  type        = string
  description = "Name of the IAM role"
}

variable "policy_name" {
  type        = string
  description = "Name of the IAM policy"
}

variable "statements" {
  type = list(object({
    Effect    = string
    Action   = list(string)
    Resource = list(string)
  }))
  description = "List of IAM policy statements"
  default = [
    {
      Effect    = "Allow"
      Action   = ["cloudwatch:*", "logs:*", "sns:*"]
      Resource = ["*"]
    },
  ]
}