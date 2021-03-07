terraform {
  required_version = ">=0.14.0"
  required_providers {
    aws = ">=3.0.0"
  }
  backend "s3" {
    region  = "us-east-1"
    profile = "default"
    key     = "terraform-statefile-juansidberry_com"
    bucket  = "dyx-terraform-tfstates-useast1"
  }
}

provider "aws" {
  region = "us-east-1"
  # access_key = var.aws_access_key
  # secret_key = var.aws_secret_key
}
