output "arn" {
  description = "The ARN of the bucket"
  value       = aws_s3_bucket.website.arn
}

output "id" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.website.id
}

output "bucket_regional_domain_name" {
  description = "Bucket's regional domain name"
  value       = aws_s3_bucket.website.bucket_regional_domain_name
}
