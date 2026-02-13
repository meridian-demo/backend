resource "aws_s3_bucket" "demo" {
  bucket = "${local.name_prefix}-bucket"
  tags   = local.tags
}

resource "aws_s3_bucket_versioning" "demo" {
  bucket = aws_s3_bucket.demo.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "demo" {
  bucket = aws_s3_bucket.demo.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "demo" {
  bucket = aws_s3_bucket.demo.id

  rule {
    id     = "expire-noncurrent"
    status = "Enabled"

    noncurrent_version_transition {
      newer_noncurrent_versions = 1
      storage_class             = "STANDARD_IA"
      noncurrent_days           = 30
    }

    noncurrent_version_expiration {
      newer_noncurrent_versions = 2
      noncurrent_days           = 90
    }
  }
}

resource "aws_s3_bucket_public_access_block" "demo" {
  bucket = aws_s3_bucket.demo.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


