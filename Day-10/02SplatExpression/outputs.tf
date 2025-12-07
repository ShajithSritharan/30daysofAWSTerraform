output "aws_instance_id" {
  description = "The ID of the AWS instance"
  value       = aws_instance.conditional_expression[*].id
}

output "instances" {
  description = "List of all instance IDs"
  value       = local.all_instance_ids
}
