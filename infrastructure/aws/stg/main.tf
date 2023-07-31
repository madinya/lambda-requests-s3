terraform {

  backend "s3" {
    bucket  = "dev-rmc-tfstate"
    key     = "terraform/state/lambda-requests-s3-stg.tfstate"
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
  bucket_name = "${local.repo}-${local.stage}"
}


resource "aws_s3_object" "lambda_template_zip" {
  bucket = module.lambda_code_bucket.bucket_name
  key    = "${local.repo}.zip"
  source = "../lambda_template/${local.repo}.zip"
}

module "lambda_function" {
  source        = "../common/lambda"
  s3_bucket     = module.lambda_code_bucket.bucket_name
  s3_key        = "${local.repo}.zip"
  function_name = "${local.repo}_fn_${local.stage}"
  role_name     = "${local.repo}_lambda_role_${local.stage}"
  policy_name   = "${local.repo}_lambda_policy_${local.stage}"

  env_variables = [{
    "ENV" = local.stage
    }
  ]
  depends_on = [aws_s3_object.lambda_template_zip]
}