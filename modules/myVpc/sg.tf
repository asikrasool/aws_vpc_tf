resource "aws_security_group" "My_VPC_Security_Group" {
  name        = "My_VPC_Security_Group"
  description = "Ingress for My_VPC_Security_Group"
  vpc_id      = aws_vpc.My_VPC.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.egress_cidrblock
  }
tags = {
   Name = "My VPC Security Group"
   Description = "My VPC Security Group"
}
}
locals {
    ports               = [80, 443,22]
    cidrs               = var.ingress_cidrblock
    ingress_rules_tuple = setproduct(local.ports, local.cidrs)
    ingress_rules = {
    for pair in local.ingress_rules_tuple :
    "${pair[0]}-${pair[1]}" => pair
    }
}
resource "aws_security_group_rule" "demo_ingress" {
    for_each          = local.ingress_rules
    type              = "ingress"
    description       = "Ingress from ${each.value[1]} port ${each.value[0]}"
    security_group_id = aws_security_group.My_VPC_Security_Group.id
    cidr_blocks       = [each.value[1]]
    protocol          = "tcp"
    from_port         = each.value[0]
    to_port           = each.value[0]
}
# resource "aws_security_group_rule" "My_VPC_Security_Group_rule" {
#   dynamic "ingress" {
#     iterator = port
#     for_each = var.ingress_ports
#     content {
#       from_port   = port.value
#       to_port     = port.value
#       protocol    = "tcp"
#       cidr_blocks = var.ingress_cidrblock
#       security_group_id = "aws_security_group.My_VPC_Security_Group.id"
#     }
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = var.egress_cidrblock
#     security_group_id = "aws_security_group.My_VPC_Security_Group.id"
#   }
# }
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

