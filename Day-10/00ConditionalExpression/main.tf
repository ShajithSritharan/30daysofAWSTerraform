resource "aws_instance" "conditional_expression" {
  ami           = "ami-0ff8a91507f77f867"
  count = var.instance_count
  #instance_type = "t2.micro" #instead of hardcoding we will use conditional expression
  instance_type = var.environment == "dev" ? "t2.micro" : "t3.micro"
  tags = var.tags
}