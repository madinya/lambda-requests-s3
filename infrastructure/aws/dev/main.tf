terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.9.0"
    }
  }
  backend "s3" {
    bucket  = "dev-rmc-tfstate"
    key     = "terraform/state/lambda-requests-s3-dev.tfstate"
    region  = "us-east-1"
    encrypt = true
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

module "role_lambda" {
  source      = "../common/iam"
  role_name   = "${local.repo}-lambda-role-${local.stage}"
  policy_name = "${local.repo}-lambda-policy-${local.stage}"
  statements = [

    {
      Effect = "Allow"
      Action = [
        "s3:ListAllMyBuckets",
        "s3:GetBucketLocation"
      ],
      Resource = ["*"]
    },
    {
      Effect = "Allow"
      Action = ["s3:*"]
      Resource = [
        "${module.lambda_code_bucket.bucket_arn}",
        "${module.lambda_code_bucket.bucket_arn}/*"
      ]
    },
    {
      Effect = "Allow"
      Action = ["autoscaling:Describe*",
        "cloudwatch:*",
        "logs:*",
      "sns:*"]
      Resource = ["*"]
    },
  ]
}


module "lambda_function" {
  source        = "../common/lambda"
  s3_bucket     = module.lambda_code_bucket.bucket_name
  s3_key        = "${local.repo}.zip"
  function_name = "${local.repo}-fn-${local.stage}"
  role_arn      = module.role_lambda.role_arn

  env_variables = [{
    "ENV" = local.stage
    }
  ]
  depends_on = [aws_s3_object.lambda_template_zip]
}