locals {
  s3_origin_id              = "S3-${var.ui_app_bucket_name}"
}

data "aws_cloudfront_cache_policy" "managed_cachingoptimized_policy" {
  name = "Managed-CachingOptimized"
}

resource "aws_cloudfront_distribution" "ui_content_distribution" {
  origin {
    domain_name = aws_s3_bucket.ui_app_bucket.bucket_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_identity.cloudfront_access_identity_path
    }
  }

  enabled         = true
  is_ipv6_enabled = true
  comment         = "Cloudfront distribution for UI App"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    viewer_protocol_policy = "redirect-to-https"
    compress = false

    cache_policy_id          = data.aws_cloudfront_cache_policy.managed_cachingoptimized_policy.id
  }

  default_root_object = "index.html"

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = var.tags

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_cloudfront_origin_access_identity" "origin_identity" {
  comment = "Origin access identity for the ui_content_distribution"
}