resource "aws_ses_domain_identity" "domain" {
  domain = var.website-domain-main
}

# resource "aws_route53_record" "amazonses_verification_record" {
#   zone_id = "ABCDEFGHIJ123"
#   name    = "_amazonses.example.com"
#   type    = "TXT"
#   ttl     = "600"
#   records = [aws_ses_domain_identity.domain.verification_token]
# }

data "aws_route53_zone" "selected" {
  name         = var.website-domain-main
  private_zone = false
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = data.aws_route53_zone.selected.name
#   name    = "www.${data.aws_route53_zone.selected.name}"
  type    = "A"
  ttl     = "300"
  records = [aws_ses_domain_identity.domain.verification_token]
}

output "route53_data" {
  description = "Data about a Route53 Domain"
  value       = data.aws_route53_zone.selected
}