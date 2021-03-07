## Route 53
# Provides details about the zone
data "aws_route53_zone" "main" {
  name         = var.website-domain-main
  private_zone = false
}

# Validates the ACM wildcard by creating a Route53 record (as `validation_method` is set to `DNS` in the aws_acm_certificate resource)
resource "aws_route53_record" "wildcard_validation" {
  name    = aws_acm_certificate.wildcard_website.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.wildcard_website.domain_validation_options[0].resource_record_type
  zone_id = data.aws_route53_zone.main.zone_id
  records = [aws_acm_certificate.wildcard_website.domain_validation_options[0].resource_record_value]
  ttl     = "60"
}

# Creates the DNS record to point on the main CloudFront distribution ID
resource "aws_route53_record" "website_cdn_root_record" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.website-domain-main
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.website_cdn_root.domain_name
    zone_id                = aws_cloudfront_distribution.website_cdn_root.hosted_zone_id
    evaluate_target_health = false
  }
}

# Creates the DNS record to point on the CloudFront distribution ID that handles the redirection website
resource "aws_route53_record" "website_cdn_redirect_record" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.website-domain-redirect
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.website_cdn_redirect.domain_name
    zone_id                = aws_cloudfront_distribution.website_cdn_redirect.hosted_zone_id
    evaluate_target_health = false
  }
}
