# S3 Bucket Configuration
# VULN: Múltiples misconfiguraciones para testing de Checkov

# VULN: S3 sin server-side encryption (CKV_AWS_19)
# VULN: S3 sin versioning (CKV_AWS_21)
# VULN: S3 sin logging (CKV_AWS_18)
resource "aws_s3_bucket" "uploads" {
  bucket = "taskmanager-uploads-${var.environment}"
  
  # VULN: ACL público (CKV_AWS_20)
  acl = "public-read"
  
  tags = {
    Name = "TaskManager Uploads"
  }
}

# VULN: Bucket policy permite acceso público (CKV_AWS_70)
resource "aws_s3_bucket_policy" "uploads_policy" {
  bucket = aws_s3_bucket.uploads.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.uploads.arn}/*"
      }
    ]
  })
}

# VULN: Sin block public access (CKV_AWS_53, CKV_AWS_54, CKV_AWS_55, CKV_AWS_56)
resource "aws_s3_bucket_public_access_block" "uploads_public_access" {
  bucket = aws_s3_bucket.uploads.id
  
  block_public_acls       = false  # VULN: Debería ser true
  block_public_policy     = false  # VULN: Debería ser true
  ignore_public_acls      = false  # VULN: Debería ser true
  restrict_public_buckets = false  # VULN: Debería ser true
}

# Bucket para logs - también vulnerable
resource "aws_s3_bucket" "logs" {
  bucket = "taskmanager-logs-${var.environment}"
  
  # VULN: Sin cifrado
  # VULN: Sin lifecycle policy
  
  tags = {
    Name = "TaskManager Logs"
  }
}
