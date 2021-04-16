## ACM (AWS Certificate Manager)
# Creates the wildcard certificate 
# Wilcard certificate used by CloudFront requires us-east-1 
# (https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/cnames-and-https-requirements.html)
resource "aws_acm_certificate" "wildcard_website" {
  # provider = aws.us-east-1

  domain_name               = var.website-domain-main
  subject_alternative_names = ["*.${var.website-domain-main}"]
  validation_method         = "DNS"

  tags = {
    ManagedBy = "terraform"
    Changed   = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

# Triggers the ACM wildcard certificate validation event
resource "aws_acm_certificate_validation" "wildcard_cert" {
  # provider = aws.region

  certificate_arn         = aws_acm_certificate.wildcard_website.arn
  validation_record_fqdns = [aws_route53_record.wildcard_validation.fqdn]

  timeouts {
    create = "60m"
  }
}

# Get the ARN of the issued certificate
data "aws_acm_certificate" "wildcard_website" {
  # provider = aws.us-east-1

  depends_on = [
    aws_acm_certificate.wildcard_website,
    aws_route53_record.wildcard_validation,
    aws_acm_certificate_validation.wildcard_cert,
  ]

  domain      = var.website-domain-main
  statuses    = ["ISSUED"]
  most_recent = true
}
