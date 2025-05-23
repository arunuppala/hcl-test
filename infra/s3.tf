# resource "aws_s3_bucket" "state" {
#   bucket        = "terraform-hcl-test-state2"
#   force_destroy = true

#   tags = {
#     Name        = "Terraform State Bucket"
#     Environment = var.env
#   }

#   lifecycle {
#     prevent_destroy = true
#   }
# }

# resource "aws_s3_bucket_versioning" "state_versioning" {
#   bucket = aws_s3_bucket.state.id

#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# resource "aws_s3_bucket_server_side_encryption_configuration" "state_encryption" {
#   bucket = aws_s3_bucket.state.id

#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm = "AES256"
#     }
#   }
# }

# resource "aws_s3_bucket_public_access_block" "state_block_public" {
#   bucket = aws_s3_bucket.state.id

#   block_public_acls       = true
#   block_public_policy     = true
#   ignore_public_acls      = true
#   restrict_public_buckets = true
# }
