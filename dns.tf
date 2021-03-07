## Route 53
# Provides details about the zone
data "aws_route53_zone" "main" {
  name         = var.website-domain-main
  private_zone = false
}