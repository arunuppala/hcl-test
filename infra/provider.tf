terraform {
  required_version = ">= 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.94" # Use ~> for safe upgrades within major versions
    }
  }
}

provider "aws" {
  region = var.region
}
