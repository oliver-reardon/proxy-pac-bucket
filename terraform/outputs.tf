# Output the cdn URL
output "cdn_url" {
  value = "https://${aws_cloudfront_distribution.cdn.domain_name}"
}
