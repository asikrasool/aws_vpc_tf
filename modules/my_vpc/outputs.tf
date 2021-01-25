output "subnet_id" {
  value = aws_subnet.My_VPC_Public_Subnet.id
}
output "ec2_sg" {
  value = [aws_security_group.My_VPC_Security_Group.id]
}

output "subnet_group" {
  value = aws_db_subnet_group.mysql.name
}

output "mysql_sg" {
  value   = [aws_security_group.mysql.id]
}