## S3
# Creates bucket to store logs
resource "aws_s3_bucket" "website_logs" {
  bucket = "${var.website-domain-main}-logs"
  acl    = "log-delivery-write"

  # Comment the following line if you are uncomfortable with Terraform destroying the bucket even if this one is not empty 
  force_destroy = true

  tags = {
    ManagedBy = "terraform"
    Changed   = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

# Creates bucket to store the static website
resource "aws_s3_bucket" "website_root" {
  bucket = "${var.website-domain-main}-root"
  acl    = "public-read"

  # Comment the following line if you are uncomfortable with Terraform destroying the bucket even if not empty 
  force_destroy = true

  logging {
    target_bucket = aws_s3_bucket.website_logs.bucket
    target_prefix = "${var.website-domain-main}/"
  }

  website {
    index_document = "index.html"
    error_document = "404.html"
  }

  tags = {
    ManagedBy = "terraform"
    Changed   = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

# Creates bucket for the website handling the redirection (if required), e.g. from https://www.example.com to https://example.com
resource "aws_s3_bucket" "website_redirect" {
  bucket        = "${var.website-domain-main}-redirect"
  acl           = "public-read"
  force_destroy = true

  logging {
    target_bucket = aws_s3_bucket.website_logs.bucket
    target_prefix = "${var.website-domain-main}-redirect/"
  }

  website {
    redirect_all_requests_to = "https://${var.website-domain-main}"
  }

  tags = {
    ManagedBy = "terraform"
    Changed   = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

# Creates policy to allow public access to the S3 bucket
resource "aws_s3_bucket_policy" "update_website_root_bucket_policy" {
  bucket = aws_s3_bucket.website_root.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "PolicyForWebsiteEndpointsPublicContent",
  "Statement": [
    {
      "Sid": "PublicReadWrite",
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": [
        "${aws_s3_bucket.website_root.arn}/*",
        "${aws_s3_bucket.website_root.arn}"
      ]
    }
  ]
}
POLICY
}

# resource "aws_s3_object_copy" "add_website_content_root" {
#   bucket = "${var.website-domain-main}-root"
#   key    = "index.html"
#   source = "juansidberry.com/index.html"
#   # source = "arn:aws:s3:::juansidberry.com/index.html"

#   depends_on = [
#     aws_s3_bucket.website_root,
#     aws_s3_bucket.website_redirect,
#     aws_s3_bucket_policy.update_website_root_bucket_policy,
#   ]
# }

# resource "aws_s3_object_copy" "add_website_content_redirect" {
#   bucket = "${var.website-domain-main}-redirect"
#   key    = "index.html"
#   source = "juansidberry.com/index.html"
#   # source = "arn:aws:s3:::juansidberry.com/index.html"

#   depends_on = [
#     aws_s3_bucket.website_root,
#     aws_s3_bucket.website_redirect,
#     aws_s3_bucket_policy.update_website_root_bucket_policy,
#   ]
# }

resource "null_resource" "s3_objects" {
  provisioner "local-exec" {
    command = "aws s3 cp s3://juansidberry.com s3://${var.website-domain-main}-root --recursive"
  }

  depends_on = [
    aws_s3_bucket.website_root,
    aws_s3_bucket.website_redirect,
    aws_s3_bucket_policy.update_website_root_bucket_policy,
  ]
}

