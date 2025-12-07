locals {
   all_instance_ids = aws_instance.conditional_expression[*].id
}