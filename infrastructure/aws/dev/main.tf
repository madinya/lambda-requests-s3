terraform {
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
