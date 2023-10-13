resource "aws_s3_bucket" "terraform_state" {
  bucket              = "${lower(var.project_name)}-terraform-state-backend"
  object_lock_enabled = true
  tags = {
    Name = "S3 Remote Terraform State Store"
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      #kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm = "aws:kms"
    }
  }
}


#resource "aws_s3_bucket_object_lock_configuration" "example" {
#  bucket = aws_s3_bucket.terraform_state.id
#}