locals {
  cloudfront_origin_access_id = aws_cloudfront_origin_access_identity.origin_identity.id
}

resource "aws_s3_bucket" "ui_app_bucket" {
  bucket = var.ui_app_bucket_name
  acl    = "private"
  tags   = var.tags
  versioning {
    enabled = true
  }

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_s3_bucket_policy" "ui_app_bucket_policy" {
  bucket = aws_s3_bucket.ui_app_bucket.id

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Id" : "GetObjectPolicy",
      "Statement" : [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${var.ui_app_bucket_name}/*"
        },
        {
            "Sid" : "2",
            "Effect" : "Allow",
            "Principal" : {
            "AWS" : "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${local.cloudfront_origin_access_id}"
            },
            "Action" : "s3:GetObject",
            "Resource" : "arn:aws:s3:::${var.ui_app_bucket_name}/*"
        }
      ]
    })
}

resource "aws_s3_bucket_public_access_block" "ui_app_bucket_access_block" {
  bucket = aws_s3_bucket.ui_app_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}