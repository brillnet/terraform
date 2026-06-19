output "aws_vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.prod-vpc.id
}

output "public_east-1a_subnet_1_id" {
  description = "public-east-1a-subnet-1 ID"
  value       = aws_subnet.public-east-1a-subnet-1.id
}

output "private-east-1a_subnet_3_id" {
  description = "Private - Subnet 3 AZ-1a ID"
  value       = aws_subnet.private-east-1a-subnet-3.id
}

output "private-east-1b_subnet_4_id" {
  description = "Private - Subnet 4 AZ-1b ID"
  value       = aws_subnet.private-east-1b-subnet-4.id
}