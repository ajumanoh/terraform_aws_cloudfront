resource "aws_s3_bucket" "website" {
  bucket        = var.bucket_name
  acl           = var.acl
  force_destroy = var.force_destroy
  tags          = var.tags

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = var.sse_algorithm
      }
    }
  }
}