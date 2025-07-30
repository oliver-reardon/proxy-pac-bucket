# S3 Bucket for Storage
resource "aws_s3_bucket" "my_bucket" {
  bucket = "${var.project_name}-bucket" # bucket name based on provided variable
}

# Upload object to S3 Bucket
resource "aws_s3_object" "pac_config" {
  bucket        = aws_s3_bucket.my_bucket.id # Target the created S3 bucket
  key           = "pac_config.js"            # Object key (file name in S3)
  source        = "pac_config.js"            # Local file to upload
  content_type  = "application/javascript"   # set content type
  cache_control = "no-cache"                 # Ensure it's served correctly by CloudFront
}

# CloudFront Origin Access Control (OAC) - Secure Access to S3
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "${var.project_name}-cloudfront-oac"
  description                       = "OAC for secure S3 access via CloudFront"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always" # Enforce signed requests
  signing_protocol                  = "sigv4"  # Required for modern AWS security
}

# Secure S3 Bucket Policy (Only Allow CloudFront to Access S3)
resource "aws_s3_bucket_policy" "oac_policy" {
  bucket = aws_s3_bucket.my_bucket.id # Apply policy to the created bucket

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowCloudFrontAccess",
        Effect = "Allow",
        Principal = {
          Service = "cloudfront.amazonaws.com" # Allow only CloudFront to access
        },
        Action   = "s3:GetObject",
        Resource = "arn:aws:s3:::${aws_s3_bucket.my_bucket.id}/*", # All objects in the bucket
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.cdn.arn # Restrict access to this CloudFront distribution only
          }
        }
      }
    ]
  })
}

# CloudFront Distribution (CDN for S3 Content Delivery)
resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name              = aws_s3_bucket.my_bucket.bucket_regional_domain_name # Connect to the S3 bucket
    origin_id                = "S3Origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id # Use OAC for secure access
  }

  enabled             = true
  default_root_object = "pac_config.js" # The file that CloudFront will serve

  # Default Cache Behavior (How CloudFront Handles Requests)
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"] # Limit to read-only operations
    cached_methods   = ["GET", "HEAD"] # Cache GET and HEAD requests
    target_origin_id = "S3Origin"

    forwarded_values {
      query_string = false # Do not forward query parameters
      cookies {
        forward = "none" # No cookies forwarded to S3
      }
      headers = ["Cache-Control"] # Forward Cache-Control header for proper caching
    }

    viewer_protocol_policy = "redirect-to-https" # Always use HTTPS
  }

  # Geographic Restrictions (Restrict Access by Country if Needed)
  restrictions {
    geo_restriction {
      restriction_type = "none" # No country restrictions by default
      locations        = []     # Add countries here if using "whitelist" or "blacklist"
    }
  }

  # CloudFront SSL Configuration (Use AWS Default Certificate)
  viewer_certificate {
    cloudfront_default_certificate = true # Use default CloudFront SSL certificate
  }
}