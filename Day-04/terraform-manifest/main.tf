terraform {

  backend "s3" {
    bucket = "my-terraform-state-bucket-50000234"
    key    = "dev/terraform.tfstate" # path within the bucket
    region = "ca-central-1"
    encrypt = true # to enable server-side encryption for the state
    use_lockfile = true # to enable state locking
  }
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  required_version = ">= 1.0.0"
}

# Configure the AWS Provider
provider "aws" {
  region = "ca-central-1"
}

# Create s3 Bucket
resource "aws_s3_bucket" "first_bucket" {
  bucket = "my-unique-bucket-name-50000123"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}