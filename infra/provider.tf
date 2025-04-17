terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.94.1"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  # access_key = "<<access_key>>"
  # secret_key = "<<secret_key>>"
}