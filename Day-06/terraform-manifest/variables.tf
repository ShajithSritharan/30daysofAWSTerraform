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