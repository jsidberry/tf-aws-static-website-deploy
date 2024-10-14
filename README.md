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

## NOTES:
- in the `variables.tf` file, the default values are examples of what I used. Please either (1) replace the defaults to your/different domain name, or (2) define the value of the variables in the `terraform.tfvars` file that you create to define youe own variables.
- in the `main.tf` file, the values for `terraform.backend.s3.bucket` and `terraform.backend.s3.key` need to get updated to YOUR S3 bucket and key.
- waht is missing, for security reasons, is the `terraform.tfvars` files as that is where you define the values to your variables. 

So, it looks like the prerequisites are:
- have an S3 **bucket** and **key** already created. designate it in the `main.tf` files
- have your AWS credentials already set in your local runtime environment. if not, set them in an environment variable.