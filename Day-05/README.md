# #30daysofAWSTerraform

## Day 05 - Terraform Variables in AWS: Input vs Output vs Local

![Terraform variable flow](./varaible.drawio.png)

Variables turn a static Terraform file into a reusable blueprint. In AWS this means one configuration can create dev, stage, or prod stacks simply by switching values. Below is a concise guide and a hands-on example pulled from `terraform-manifest/main.tf` (provider region is set to `ca-central-1`).

### What you'll learn
- When to use input variables and how to declare them.
- How locals keep names and tags consistent across resources.
- How outputs surface important IDs for humans and parent modules.
- How Terraform variable precedence works (defaults, tfvars, env vars, CLI).
- How to run the sample stack and override values safely.

### Watch
- Video walkthrough: [Terraform Variables in AWS (YouTube)](https://www.youtube.com/watch?v=V-2yC39BONc&t=89s)
- Thumbnail: [![Terraform variables video thumbnail](https://img.youtube.com/vi/V-2yC39BONc/maxresdefault.jpg)](https://www.youtube.com/watch?v=V-2yC39BONc&t=89s)

### Input variables (what you pass in)
- Declare once, reuse everywhere: they keep resource blocks clean and let you set values at plan/apply time.
- Example declarations:
```hcl
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
```
- Use with the `var.` prefix: `var.bucket_name`, `var.environment`.

### Local values (derived helpers)
- Locals compute once and read many times; great for tags and name patterns.
```hcl
locals {
  common_tags = {
    Project     = "terraformdemo"
    Environment = var.environment
  }
}
```
- Resources then stay consistent:
```hcl
resource "aws_s3_bucket" "first_bucket" {
  bucket = "${local.common_tags["Project"]}-${local.common_tags["Environment"]}-${var.bucket_name}"
  tags   = local.common_tags
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${local.common_tags["Project"]}-${local.common_tags["Environment"]}-VPC"
  }
}

resource "aws_instance" "my_ec2" {
  ami           = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
  instance_type = "t2.micro"
  tags = {
    Name = "${local.common_tags["Project"]}-${local.common_tags["Environment"]}-EC2"
  }
}
```

### Output values (what you expose)
- Outputs make important IDs visible after apply or to parent modules.
```hcl
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
```
- Sample output after apply:
```bash
terraform output
ec2_instance_id = "i-068520d20348a63be"
s3_bucket_name  = "terraformdemo-dev-my-unique-bucket-name-50000123"
vpc_id          = "vpc-03b131e058d4c3c4d"
```

### Variable precedence (low -> high)
```text
variable "default"
      |
TF_VAR_name environment variables
      |
terraform.tfvars / terraform.tfvars.json
      |
*.auto.tfvars / *.auto.tfvars.json
      |
-var / -var-file (highest)
```

### Passing values in this example
- Defaults: bucket name and environment are preset for quick demos.
- `.tfvars` file: `terraform-manifest/terraform.tfvars` contains `environment = "preprod"` to flip tags and names.
- Environment override: `export TF_VAR_environment=stage` beats the tfvars and switches everything to stage.
- CLI override: `terraform plan -var "bucket_name=my-new-bucket"` wins over every other source.

### Run it yourself (AWS credentials required)
```bash
cd terraform-manifest
terraform init
# optional: override defaults
export TF_VAR_environment=stage               # or edit terraform.tfvars
terraform plan -var "bucket_name=my-bucket"   # inspect changes
terraform apply                               # create S3, VPC, EC2
terraform output                              # read the IDs and names
```

### Clean up
```bash
cd terraform-manifest
terraform destroy    # tear down S3, VPC, EC2 to avoid unwanted AWS costs
```

With these three kinds of variables, you can keep one Terraform config flexible across many AWS environments while keeping names, tags, and outputs predictable.

### Summary
- Input variables let you parameterize configs per environment or run.
- Locals keep naming and tagging consistent without repetition.
- Outputs surface the IDs you need after apply or to feed parent modules.
- Precedence decides which values win: defaults < env vars < tfvars < auto tfvars < CLI flags.
- Run, override, and destroy safely to keep AWS costs controlled.
