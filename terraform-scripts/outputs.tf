### key resources outputs ###
output "vpc_id" {
  value = aws_vpc.main.id
  description = "VPC_ID"
}

output "public_subnet_id" {
  value = aws_subnet.public.id
  description = "Public Subnet ID"
}

output "alb_dns_name" {
  value =  aws_lb.app_lb.dns_name
  description = "Application Load Balancer DNS Name"
}

output "private_subnet_id" {
  value = aws_subnet.private.id
  description = "Private Subnet ID"
}

output "db_endpoint" {
  value = aws_db_instance.postgresql.endpoint
  description = "RDS Database Endpoint"
  sensitive = true
}

output "db_username" {
  value = aws_db_instance.postgresql.username
  description = "RDS Database Username"
}