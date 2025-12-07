# #30DaysOfAWSTerraform

## Day 10 - AWS Terraform Conditional Expressions, Splat Expressions and Dynamic Block

### Learning objectives
-   Use conditional expressions to avoid repeating code and make resources more flexible.
-   Use dynamic blocks to generate repeated nested blocks (like multiple ingress rules) from variables.
-   Use splat expressions to quickly collect multiple attribute values (like all instance IDs) in a single line.

### Terraform Expressions

Terraform expressions help you avoid hardcoding values and repeating code.

Instead of writing the same logic again and again, you can use expressions to:

Change values based on conditions (environment, count, etc.).

Generate nested blocks from input collections.

Extract multiple values from resources.

### Types of Expressions

![Terraform Expressions](./expression.drawio.png)

1. Conditional Expression: basically it's kind of true or false
```hcl
condition ? true_value : false_value
```
ex:
```hcl
var.env == dev ? var.instance_type = "t2.micro" : var.instance = "t3.micro"
```
Let's experiment with conditional expression.
condition part is evaluated first, then it checks the true value and the false value.
so instance_type will be assigned based on the condition if it is true or not.

```hcl
resource "aws_instance" "conditional_expression" {
  ami           = "ami-0ff8a91507f77f867"
  count = var.instance_count
  #instance_type = "t2.micro" #instead of hardcoding we will use conditional expression
  instance_type = var.environment == "dev" ? "t2.micro" : "t3.micro"
  tags = var.tags
}
```
environment variable set as "dev" in tfvars file.
observed the both instances are created as "t2.micro"
```bash
tf plan | grep "instance_type" 
      + instance_type                        = "t2.micro"
      + instance_type                        = "t2.micro"
```

let's change the input variable for environment as "staging" and check the output
```bash
tf plan | grep "instance_type" 
      + instance_type                        = "t3.micro"
      + instance_type                        = "t3.micro"
```


2. Dynamic Blocks: helps us to write nested block with multiple values

Dynamic blocks help you generate nested blocks (like ingress inside a security group) from a list or map, without copying and pasting the same block many times.

```hcl
dynamic "block_name" {
    for_each = var.collection
    content {
        #content
    }
}
```
variable name is ingress rules is a list of objects, where object is a data type that contains multiple data types within it
```hcl
variable "ingress_rules" {
  description = "List of ingress rules for security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}
```

You didn’t manually write 3 separate ingress blocks—Terraform generated them using the dynamic block.
Output:
```bash
 ingress                = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + from_port        = 22
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 22
                # (1 unchanged attribute hidden)
            },
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + from_port        = 443
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 443
                # (1 unchanged attribute hidden)
            },
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + from_port        = 80
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 80
                # (1 unchanged attribute hidden)
            },
        ]
```

we can add one more ingress rule by using dynamic block without rewriting the security rule again.


3. Splat Expressions: one liner code to retrieve multiple values with a just single line using * operator

It lets you collect the same attribute from multiple resources into a single list using the [*] operator.

```hcl
resource_list[*].attribute
```

We want to create a list of variables which have all the instance ids.
Use the [*] operator before the actual field.
attribute can be : id, private_ip, name etc
```hcl
locals {
   all_instance_ids = aws_instance.conditional_expression[*].id
}
```
This is very handy when:

You create multiple instances using count or for_each.

You want a list of all their IDs, private IPs, etc.
```hcl
locals {
   all_instance_ids = aws_instance.conditional_expression[*].id
}

output "aws_instance_id" {
  description = "The ID of the AWS instance"
  value       = aws_instance.conditional_expression[*].id
}
```


Output:
```bash
Changes to Outputs:
  + aws_instance_id = [
      + (known after apply),
      + (known after apply),
    ]
  + instances       = [
      + (known after apply),
      + (known after apply),
    ]
```

### Summary

- Conditional expressions help you switch values based on environment or conditions, instead of hardcoding.

- Dynamic blocks let you generate repeated nested blocks (like multiple security group rules) from a variable, keeping code clean and DRY.

- Splat expressions allow you to collect the same attribute from multiple resources (like all instance IDs) in a single line.

### References
1. https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
2. https://aws.amazon.com/amazon-linux-ami/
3. https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
