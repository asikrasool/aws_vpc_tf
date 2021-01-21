resource "aws_security_group" "My_VPC_Security_Group" {
  name        = "My_VPC_Security_Group"
  description = "Ingress for My_VPC_Security_Group"
  vpc_id      = aws_vpc.My_VPC.id

  dynamic "ingress" {
    iterator = port
    for_each = var.ingress_ports
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = var.ingressCIDRblock
    }
  }
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
resource aws_security_group "mysql" {
  name        = "${var.stack}-DBSG"
  description = "managed by terrafrom for db servers"
  vpc_id      = aws_vpc.My_VPC.id

  tags = {
    Name = "${var.stack}-DBSG"
  }

  ingress {
    protocol        = "tcp"
    from_port       = 3306
    to_port         = 3306
    security_groups = [aws_security_group.My_VPC_Security_Group.id]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

