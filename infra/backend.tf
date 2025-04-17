# resource "aws_s3_bucket" "state" {
#   bucket        = "terraform-hcl-test-state"
#   force_destroy = true

#   tags = {
#     Name = "My bucket"
#   }

#   lifecycle {
#     prevent_destroy = true
#   }
# }

# resource "aws_s3_bucket_versioning" "name" {
#   bucket = aws_s3_bucket.state.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state" {
#   bucket = aws_s3_bucket.state.id

#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm = "AES256"
#     }
#   }
# }

terraform {
  backend "s3" {
    bucket       = "terraform-hcl-test-state"
    key          = "terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}