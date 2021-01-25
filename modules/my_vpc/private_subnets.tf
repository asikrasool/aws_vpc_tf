# create the Private Subnet
data "aws_availability_zones" "azs" {

}
resource "aws_subnet" "My_VPC_Private_Subnet" {
  depends_on = [
    aws_vpc.My_VPC,
    aws_subnet.My_VPC_Public_Subnet
  ]
  vpc_id = aws_vpc.My_VPC.id
  #count                   = 
  cidr_block              = var.private_subnet1_cidrblock
  availability_zone       = data.aws_availability_zones.azs.names[0]
  map_public_ip_on_launch = false
  tags = {
    Name = "My VPC Private Subnet"
  }
}

resource "aws_subnet" "My_VPC_Private_Subnet2" {
  depends_on = [
    aws_vpc.My_VPC,
    aws_subnet.My_VPC_Public_Subnet
  ]
  vpc_id = aws_vpc.My_VPC.id
  #count                   = 
  cidr_block              = var.private_subnet2_cidrblock
  availability_zone       = data.aws_availability_zones.azs.names[1]
  map_public_ip_on_launch = false
  tags = {
    Name = "My VPC Private Subnet"
  }
}


# Subnet Group
resource "aws_db_subnet_group" "mysql" {
  name       = "${var.stack}-subngroup"
  subnet_ids = [aws_subnet.My_VPC_Private_Subnet.id,aws_subnet.My_VPC_Private_Subnet2.id]
  tags = {
    Name = "${var.stack}-subnetGroup"
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
    cidr_block     = var.destination_cidrblock
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
resource "aws_route_table_association" "Nat-Gateway-RT-Association1" {
  depends_on = [
    aws_route_table.nat_gateway_rt
  ]
  #  Private Subnet ID for adding this route table to the DHCP server of Private subnet!
  subnet_id = aws_subnet.My_VPC_Private_Subnet2.id
  # Route Table ID
  route_table_id = aws_route_table.nat_gateway_rt.id
}