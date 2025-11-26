terraform {
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