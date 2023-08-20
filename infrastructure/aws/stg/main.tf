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
  region = local.region
}

data "aws_caller_identity" "current" {}

module "my_bucket" {
  source      = "../common/s3"
  bucket_name = "${local.repo}-${local.stage}"
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
        "${module.my_bucket.bucket_arn}",
        "${module.my_bucket.bucket_arn}/*"
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
  source                = "../common/lambda"
  filename              = "../../../${local.repo}.zip"
  filename_requirements = "../../../${local.repo}-requirements.zip"
  handler               = "lambda_function.lambda_handler"
  role_arn              = module.role_lambda.role_arn
  repo                  = local.repo
  stage                 = local.stage

  source_arn = module.my_api_gateway.execution_arn
  env_variables = [{
    "ENV"    = local.stage
    "BUCKET" = module.my_bucket.bucket_name
    }
  ]
}

module "my_api_gateway" {
  source               = "../common/api-gateway"
  lambda_function_arn  = module.lambda_function.invoke_arn
  lambda_function_name = module.lambda_function.function_name
  stage                = local.stage
  repo                 = local.repo
}