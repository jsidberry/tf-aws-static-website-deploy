terraform {
  required_version = var.tf_required_version
  required_providers {
    aws = var.aws_required_version
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
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

module "aws_static_website" {
  source = "cloudmaniac/static-website/aws"

  website-domain-main     = var.website-domain-main
  website-domain-redirect = var.website-domain-redirect
}
