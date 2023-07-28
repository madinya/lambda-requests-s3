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
  bucket_name = "lambda-requests-s3-${local.stage}"
}
