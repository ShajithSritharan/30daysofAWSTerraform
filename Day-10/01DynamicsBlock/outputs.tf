output "aws_instance_id" {
  description = "The ID of the AWS instance"
  value       = aws_instance.conditional_expression[*].id
}