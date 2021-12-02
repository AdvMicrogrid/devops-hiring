resource "aws_s3_bucket" "backups" {
  bucket = "ams-${var.name}-scylla-cluster-backups"

  lifecycle_rule {
    enabled = true
    expiration {
      days = var.backup_bucket_expiration
    }
  }
}

