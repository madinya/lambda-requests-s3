terraform {

  backend "s3" {
    bucket  = "dev-rmc-tfstate"
    key     = "terraform/state/stg-lambda-requests-s3.tfstate"
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

module "s3" {
  source      = "../common/s3"
  bucket_name = "${local.stage}-lambda-requests-s3"
}
