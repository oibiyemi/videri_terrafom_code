

/// AWS_S3_BUCKET_SERVER_SIDE 
#  The resource I chose here is aws_s3_bucket_server_side_encryption_configuration 
# because "aws_s3_bucket" is deprecated
#  It is highly recommended that you enable Bucket Versioning on the S3 bucket 
# to allow for state recovery in the case of accidental deletions and human error.

resource "aws_kms_key" "videri_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "videri_bucket" {
  bucket = "videri-terraform-state-backend"
}

resource "aws_s3_bucket_acl" "videri_bucket_acl" {
  bucket = aws_s3_bucket.videri_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.videri_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket_server_side_encryption_configuration" "sse_videri" {
  bucket = aws_s3_bucket.videri_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.videri_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}


///DYNAMODB

resource "aws_dynamodb_table" "terraform-lock" {
  name           = "videri_terraform_state"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID" # must be LockID
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    "Name" = "videri DynamoDB Terraform State Lock Table"
  }
}