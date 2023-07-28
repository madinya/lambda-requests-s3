terraform {

  backend "s3" {
    bucket  = "dev-rmc-tfstate"
    key     = "terraform/state/lambda-requests-s3.tfstate"
    region  = "us-east-1"
    encrypt = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.9.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
data "aws_caller_identity" "current" {}

module "lambda_code_bucket" {
  source      = "../common/s3"
  bucket_name = "lambda-requests-s3-${local.stage}"
}
module "lambda_function" {
  source        = "../common/lambda"
  s3_bucket     = module.lambda_code_bucket.bucket_name
  s3_key        = local.s3_key
  function_name = "${local.repo}_fn_${local.repo}"
  role_name     = "${local.repo}_lambda_role_${local.repo}"
  policy_name   = "${local.repo}_lambda_policy_${local.repo}"

  env_variables = [{
    "ENV" = local.stage
    }
  ]
}