output "subnet_id" {
  value = aws_subnet.My_VPC_Public_Subnet.id
}
output "sg_ids" {
  value = [aws_security_group.My_VPC_Security_Group.id]
}