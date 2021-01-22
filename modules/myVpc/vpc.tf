# create the VPC
resource "aws_vpc" "My_VPC" {
  cidr_block           = var.vpc_cidrblock
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.dns_support
  enable_dns_hostnames = var.dnsHostNames
  tags = {
    Name = "My VPC"
  }
} 