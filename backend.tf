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