resource "aws_instance" "conditional_expression" {
  ami           = "ami-0ff8a91507f77f867"
  count = var.instance_count
  #instance_type = "t2.micro" #instead of hardcoding we will use conditional expression
  instance_type = var.environment == "dev" ? "t2.micro" : "t3.micro"
  tags = var.tags
}

resource "aws_security_group" "ingress_rule" {
  name   = "sg"
  #vpc_id = aws_vpc.default.id; if we remove it will create in default VPC

#dynamic variable: value will  be changed as per the iterated values
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  egress  = []
}