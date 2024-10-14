# you MUST use "us-east-1" as the ACM only works in that region
variable "aws_region" {
  type    = string
  default = "us-east-1"
}

# make this YOUR domain name, this is mine for example
variable "website-domain-main" {
  type    = string
  default = "juansidberry.com"
}

# make this YOUR domain name, this is mine for example
variable "website-domain-redirect" {
  type    = string
  default = "www.juansidberry.com"
}

# make this YOUR domain name, this is mine for example
variable "source-website-content" {
  type    = string
  default = "juansidberry.com"
}
