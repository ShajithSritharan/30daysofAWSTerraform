
#Create a EC2 instance
resource "aws_instance" "my_ec2" {
  #count is expected to be a number type
  #count = var.instance_count #optional , basically to create multiple instances
  count = var.config.instance_count

  ami           = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
  instance_type = var.allowed_vm_types[1]
  #region = var.allowed_region[0] #can not access by index if set type
  #region = tolist(var.allowed_region)[0]
  region = var.config.region
  monitoring = var.config.monitoring
  associate_public_ip_address = var.associate_public_ip
  tags = var.tags
}


resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"

  tags = var.tags
}

#Security Group Rule itself a seperate resource
resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = var.cidr_block[0]
  from_port         = var.ingress_values[0]
  ip_protocol       = var.ingress_values[1]
  to_port           = var.ingress_values[2]
}



resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
