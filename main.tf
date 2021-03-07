terraform {
  required_version = ">=0.14.0"
  required_providers {
    aws = ">=3.0.0"
  }
  backend "s3" {
    region  = var.aws_region
    profile = "default"
    key     = var.tf_statefile_key
    bucket  = var.tf_statefile_bucket
  }
} 

provider "aws" {
  region     = var.aws_region
  # access_key = var.aws_access_key
  # secret_key = var.aws_secret_key
}
