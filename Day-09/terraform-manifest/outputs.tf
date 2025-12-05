
#define outputs
output "s3_bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.compliance_bucket.bucket
}

/**
output "ec2_instance_ids" {
  description = "The IDs of the EC2 instances"
  value       = aws_instance.example[*].id
}
**/