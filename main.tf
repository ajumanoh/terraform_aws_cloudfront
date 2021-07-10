terraform {
      backend "s3" {
      bucket = "terraformajumano"
      key    = "cloudformation/dev/terraform.tfstate"
      region = "us-east-1"
      dynamodb_table = "terraformstate"
   }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.48"
    }
  }
  required_version = ">= 0.15.5"
}

################################################################
# PROVIDERS                                                    #
################################################################

provider "aws" {

  profile = "default"
  region  = var.region
  default_tags {
    tags = {
      Environment = var.environment
      Name        = "full_stack"
    }
  }
}

locals {
  tags = {
    created_by = "terraform"
  }
}

################################################################
# DATA                                                         #
################################################################

data "aws_iam_policy_document" "s3policy" {
  statement {
    actions = ["s3:GetObject"]

    resources = [
      module.aws_s3_bucket.arn,
      "${module.aws_s3_bucket.arn}/*"
    ]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.oai.iam_arn]
    }
  }
}

################################################################
# RESOURCES                                                    #
################################################################
module "aws_s3_bucket" {

  source      = "./modules/S3"
  bucket_name = var.bucket_name
  tags        = local.tags
}

//Block Public Access for S3 
resource "aws_s3_bucket_public_access_block" "s3block" {
  bucket                  = module.aws_s3_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_cloudfront_distribution" "cf" {
  enabled = true
  #  aliases             = [var.endpoint]
  default_root_object = "index.html"

  origin {
    domain_name = module.aws_s3_bucket.bucket_regional_domain_name
    origin_id   = module.aws_s3_bucket.bucket_regional_domain_name

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = module.aws_s3_bucket.bucket_regional_domain_name
    viewer_protocol_policy = "allow-all"

    forwarded_values {
      headers      = []
      query_string = true

      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
      cloudfront_default_certificate = true
 #   acm_certificate_arn      = aws_acm_certificate.cert.arn
 #   ssl_support_method       = "sni-only"
 #   minimum_protocol_version = "TLSv1.2_2018"
 }

  tags = local.tags
}

resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "Cloudfront OAI to access S3"
}


# Update S3 bucket policy to allow get access for Objects - Only for CF OAI
resource "aws_s3_bucket_policy" "s3policy" {
  bucket = module.aws_s3_bucket.id
  policy = data.aws_iam_policy_document.s3policy.json
}
