output "vpc_id" {
    value = aws_vpc.main.id
}

output "rds_subnet_ids" {
    value = aws_subnet.rds_private[*].id
}

output "rds_security_group_id" {
    value = aws_security_group.rds.id
}
  