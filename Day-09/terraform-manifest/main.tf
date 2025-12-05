
# ==============================
# Example 1: create_before_destroy
# Use Case: EC2 instance that needs zero downtime during updates
# ==============================

resource "aws_instance" "example" {
  #ami           = "ami-0ff8a91507f77f867"
  ami           = "ami-0f00d706c4a80fd93"
  instance_type = var.allowed_vm_types[1] #accessing second element from the list
  region        = var.region

  tags = var.tags

  #life cycle rueles
  lifecycle {
    create_before_destroy = false #means destroy first then create
  }
}

# ==============================
# Example 2: prevent_destroy
# Use Case: Critical S3 bucket that should never be accidentally deleted
# ==============================

resource "aws_s3_bucket" "my_bucket" {
  count = 1
  #bucket = var.bucket_names[count.index] #accessing bucket name from the list
  bucket = var.bucket_names[count.index] #accessing bucket name from the set

  #Set doesnot have indexes. only list ahve indexes

  tags = var.tags

  lifecycle {
    #prevent_destroy = true #prevents accidental deletion of the resource
  }
}

# ==============================
# Example 3: ignore_changes
# Use Case: Auto Scaling Group where capacity is managed externally
# ==============================

resource "aws_launch_template" "app_server" {
  name_prefix   = "app-server-"
  image_id      = "ami-0f00d706c4a80fd93"
  instance_type = var.allowed_vm_types[0]

  tag_specifications {
    resource_type = "instance"
    tags = merge(
      var.tags,
      {
        Name = "App Server from ASG"
        Demo = "ignore_changes"
      }
    )
  }
}

#Auto Scaling Group
resource "aws_autoscaling_group" "app_servers" {
  name               = "app-servers-asg"
  min_size           = 1
  max_size           = 3
  desired_capacity   = 2
  health_check_type  = "EC2"
  availability_zones = ["us-east-1a", "us-east-1b","us-east-1c"]

  launch_template {
    id      = aws_launch_template.app_server.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "App Server ASG"
    propagate_at_launch = true
  }

  tag {
    key                 = "Demo"
    value               = "ignore_changes"
    propagate_at_launch = false
  }

  # Lifecycle Rule: Ignore changes to desired_capacity
  # This is useful when auto-scaling policies or external systems modify capacity
  # Terraform won't try to revert capacity changes made outside of Terraform
  lifecycle {
    ignore_changes = [
      desired_capacity,
      # Also ignore load_balancers if added later by other processes
    ]
  }
}

# ==============================
# Example 4: replace_triggered_by
# Use Case: Replace EC2 instances when security group changes
# ==============================

# Security Group
resource "aws_security_group" "app_sg" {
  name        = "app-security-group"
  description = "Security group for application servers"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP from anywhere"
  }
##Adding SSH 
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH from anywhere"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS from anywhere"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(
    var.tags,
    {
      Name = "App Security Group"
      Demo = "replace_triggered_by"
    }
  )
}

# EC2 Instance that gets replaced when security group changes
resource "aws_instance" "app_with_sg" {
  ami                    = "ami-0f00d706c4a80fd93"
  instance_type          = var.allowed_vm_types[0]
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tags = merge(
    var.tags,
    {
      Name = "App Instance with Security Group"
      Demo = "replace_triggered_by"
    }
  )

  # Lifecycle Rule: Replace instance when security group changes
  # This ensures the instance is recreated with new security rules
  lifecycle {
    replace_triggered_by = [
      aws_security_group.app_sg.id
    ]
  }
}


# ==============================
# Example 5: pecondition and postcondition
# Use Case: Ensure S3 bucket has required tags after creation
# ==============================

resource "aws_s3_bucket" "compliance_bucket" {
  bucket = var.bucket_names[0]

  tags = merge(
    var.tags,
    {
      Name       = "Compliance Validated Bucket"
      Demo       = "postcondition"
      Compliance = "SOC2"
    }
  )

  # Lifecycle Rule: Validate bucket has required tags after creation
  # This ensures compliance with organizational tagging policies
  lifecycle {
    precondition {
      condition     = contains(var.allowed_environments, var.environment)
      error_message = "Environment '${var.environment}' is not approved for bucket creation. Allowed environments: ${join(", ", var.allowed_environments)}"
    }
    postcondition {
      condition     = contains(keys(var.tags), "Environment")
      error_message = "ERROR: Bucket must have an 'Environment' tag!"
    }
  }
}


