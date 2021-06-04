# tf-aws-static-website-deploy
Create Static Websites on AWS by using Terraform to deploy it.

This code deploys a static website to AWS by using:
1. `S3`: file storage for the site (HTML, CSS, and Javascript)
2. `CloudFront`: a CDN for delivering (serving) the site
3. `Route53`: a DNS service for routing web traffic for the site
4. `Certificate Manager`: helps make site secure (to an extent)

## Dependancies
* Must already have a registered domain name on AWS for this to work.
If you have a domain name registered on another platform, this tf-configurtion will not work and may have some augmentation for the other platform.

