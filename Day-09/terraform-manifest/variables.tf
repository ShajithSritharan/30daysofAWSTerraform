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

variable "allowed_environments" {
  description = "Environments permitted for bucket creation"
  type        = set(string)
  default     = ["dev", "qa", "staging", "preprod", "prod"]
}

variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
}

variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "monitoring_enabled" {
  description = "Enable detailed monitoring for EC2 instances"
  type        = bool
  default     = true
}

variable "associate_public_ip" {
  description = "Associate a public IP address with the EC2 instances"
  type        = bool
  default     = true
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = list(string)
  default     = ["10.0.0.0/8", "192.168.1.0/16", "172.16.0.0/12"] # combination of multiple strings with index 0, 1, 2
}

variable "allowed_vm_types" {
  description = "List of allowed VM instance types"
  type        = list(string)
  default     = ["t2.micro", "t2.small", "t3.micro", "t3.small"]
}

variable "allowed_region" {
  description = "List of allowed AWS regions"
  type        = set(string) #duplicates are not alloweed; can not access by index
  default     = ["us-east-1", "us-west-2", "eu-west-1"]
}

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default = {
    environment = "dev"
    Name        = "dev-instance"
    Owner       = "admin"
    Project     = "terraformdemo"
    Environment = "dev"
    Compliance  = "yes"
  }
}

#Tuple type variable
variable "ingress_values" {
  description = "List of ingress port values"
  type        = tuple([number, string, number]) #sequence matters
  default     = [443, "tcp", 443]
}

#object type variable
variable "config" {
  description = "Configuration for the EC2 instance"
  type = object({
    region         = string,
    monitoring     = bool,
    instance_count = number
  })
  default = {
    region         = "us-east-1",
    monitoring     = true,
    instance_count = 1
  }
}

#map has single data type for all values where object can have different data types for values
#when you have to group common values together

variable "bucket_names" {
  description = "A list of S3 bucket names"
  type        = list(string)
  default     = ["my-unique-bucket-day08-12345", "my-unique-bucket-day08-67890"]
}

variable "bucket_names_set" {
  description = "A map of S3 bucket names"
  type        = set(string)
  default     = ["my-unique-bucket-day08-123459", "my-unique-bucket-day08-678900"]

}
