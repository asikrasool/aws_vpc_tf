# vpc.tf 
# Create VPC/Subnet/Security Group/Network ACL
terraform {
    required_version = ">= 0.12" 
}

# Create the Security Group
resource "aws_security_group" "My_VPC_Security_Group" {
  vpc_id       = aws_vpc.My_VPC.id
  name         = "My VPC Security Group"
  description  = "My VPC Security Group"
  
  # allow ingress of port 22
  ingress {
    cidr_blocks = var.ingressCIDRblock  
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  } 
  
  # allow egress of all ports
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.egressCIDRblock
  }
tags = {
   Name = "My VPC Security Group"
   Description = "My VPC Security Group"
}
}
# create VPC Network access control list
resource "aws_network_acl" "My_VPC_Security_ACL" {
  vpc_id = aws_vpc.My_VPC.id
  subnet_ids = [ aws_subnet.My_VPC_Public_Subnet.id ]
# allow ingress port 22
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.destinationCIDRblock 
    from_port  = 22
    to_port    = 22
  }
# allow egress port 22 
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 22 
    to_port    = 22
  }
tags = {
    Name = "My VPC ACL"
}
} 

