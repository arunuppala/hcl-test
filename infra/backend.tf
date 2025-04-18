terraform {
  backend "s3" {
    bucket       = "terraform-hcl-test-state2"
    key          = "terraform.tfstate"
    region       = "us-west-2"
    encrypt      = true
    use_lockfile = true
  }
}