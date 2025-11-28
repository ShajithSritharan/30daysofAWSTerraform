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

#define variables
variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "my-unique-bucket-name-50000123"  
}

variable "environment" {
    description = "The environment for the resources"
    type        = string
    default     = "dev"
}

#Define locals
locals {
    common_tags = {
        Project     = "terraformdemo"
        Environment = var.environment
    }
}

# Create s3 Bucket
resource "aws_s3_bucket" "first_bucket" {
  bucket = "${local.common_tags["Project"]}-${local.common_tags["Environment"]}-${var.bucket_name}"
  tags = local.common_tags
}

#Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
      Name = "${local.common_tags["Project"]}-${local.common_tags["Environment"]}-VPC"
  }
}

#Create a EC2 instance
resource "aws_instance" "my_ec2" {
  ami           = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
  instance_type = "t2.micro"

  tags = {
    Name = "${local.common_tags["Project"]}-${local.common_tags["Environment"]}-EC2"
  }
}

#define outputs
output "s3_bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.first_bucket.bucket
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.my_vpc.id
}   

output "ec2_instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.my_ec2.id
}  
