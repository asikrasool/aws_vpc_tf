# vpc.tf 
# Create VPC/Subnet/Security Group/Network ACL
terraform {
    required_version = ">= 0.12" 
}
# create the VPC
resource "aws_vpc" "My_VPC" {
  cidr_block           = var.vpcCIDRblock
  instance_tenancy     = var.instanceTenancy 
  enable_dns_support   = var.dnsSupport 
  enable_dns_hostnames = var.dnsHostNames
tags = {
    Name = "My VPC"
}
} 
# end resource

# create the Public Subnet
resource "aws_subnet" "My_VPC_Public_Subnet" {
  vpc_id                  = aws_vpc.My_VPC.id
  cidr_block              = var.publicSubnetCIDRblock
  map_public_ip_on_launch = var.mapPublicIP 
  availability_zone       = var.availabilityZone
tags = {
   Name = "My VPC Public Subnet"
}
}

# create the Private Subnet
resource "aws_subnet" "My_VPC_Private_Subnet" {
    depends_on = [
    aws_vpc.My_VPC,
    aws_subnet.My_VPC_Public_Subnet
  ]
  vpc_id                  = aws_vpc.My_VPC.id
  #count                   = 
  cidr_block              = var.privateSubnetCIDRblock
  availability_zone       = var.availabilityZone
  map_public_ip_on_launch = false
tags = {
   Name = "My VPC Private Subnet"
}
}

resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.My_VPC_GW]
}

# Create the Internet Gateway
resource "aws_internet_gateway" "My_VPC_GW" {
 vpc_id = aws_vpc.My_VPC.id
 tags = {
        Name = "My VPC Internet Gateway"
}
} 

# Create the Route Table
resource "aws_route_table" "My_VPC_route_table" {
 vpc_id = aws_vpc.My_VPC.id
 route {
    cidr_block = var.destinationCIDRblock
    gateway_id = aws_internet_gateway.My_VPC_GW.id
 }
 tags = {
        Name = "My VPC Route Table"
}
}

# Associate the Route Table with the Subnet
resource "aws_route_table_association" "My_VPC_association" {
  subnet_id      = aws_subnet.My_VPC_Public_Subnet.id
  route_table_id = aws_route_table.My_VPC_route_table.id
} 

/* NAT */
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.My_VPC_Public_Subnet.id
  depends_on    = [aws_internet_gateway.My_VPC_GW]
tags = {
    Name = "My_VPC_Nat_GW"
  }
}
 # end resource

 # Creating a Route Table for the Nat Gateway!
resource "aws_route_table" "nat_gateway_rt" {
  depends_on = [
    aws_nat_gateway.nat
  ]
  vpc_id = aws_vpc.My_VPC.id
  route {
    cidr_block = var.destinationCIDRblock
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "Route Table for NAT Gateway"
  }
}

# Creating an Route Table Association of the NAT Gateway route 
# table with the Private Subnet!
resource "aws_route_table_association" "Nat-Gateway-RT-Association" {
  depends_on = [
    aws_route_table.nat_gateway_rt
  ]
#  Private Subnet ID for adding this route table to the DHCP server of Private subnet!
  subnet_id      = aws_subnet.My_VPC_Private_Subnet.id
# Route Table ID
  route_table_id = aws_route_table.nat_gateway_rt.id
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

