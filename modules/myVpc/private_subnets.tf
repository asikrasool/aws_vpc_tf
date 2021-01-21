# create the Private Subnet
resource "aws_subnet" "My_VPC_Private_Subnet" {
  depends_on = [
    aws_vpc.My_VPC,
    aws_subnet.My_VPC_Public_Subnet
  ]
  vpc_id = aws_vpc.My_VPC.id
  #count                   = 
  cidr_block              = var.privateSubnetCIDRblock
  availability_zone       = var.availabilityZone
  map_public_ip_on_launch = false
  tags = {
    Name = "My VPC Private Subnet"
  }
}

/* EIP */
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.My_VPC_GW]
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
    cidr_block     = var.destinationCIDRblock
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
  subnet_id = aws_subnet.My_VPC_Private_Subnet.id
  # Route Table ID
  route_table_id = aws_route_table.nat_gateway_rt.id
}