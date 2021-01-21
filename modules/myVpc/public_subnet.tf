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