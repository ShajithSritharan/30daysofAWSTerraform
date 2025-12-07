variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default     = {
    Environment = "Dev"
    Name       =  "dev-Instance"
    created_by     = "terraform"
    compliance     = "yes"
  }  
}

variable "instance_count" {
  description = "Number of instances to create"
  type        = number
}   

variable "environment" {
  description = "The environment type"
  type        = string
  default     = "dev"
}