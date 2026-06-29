output "aws_vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.prod-vpc.id
}

output "aws_security_group_allow_web_id" {
  description = "Allow Web Inbound"
  value       = aws_security_group.allow_web.id
}

output "aws_security_group_allow_outbound_id" {
  description = "Outbound access"
  value       = aws_security_group.outbound.id
}

output "aws_security_group_allow_icmp_id" {
  description = "Allow ICMP outbound"
  value       = aws_security_group.allow_icmp.id
}

output "aws_security_group_allow_ssm_id" {
  description = "Allow SSM inbound"
  value       = aws_security_group.allow_ssm.id
}

output "public_east-1a_subnet_1_id" {
  description = "public-east-1a-subnet-1 ID"
  value       = aws_subnet.public-east-1a-subnet-1.id
}

output "public_east-1b_subnet_2_id" {
  description = "public_east_1b_subnet_2 ID"
  value       = aws_subnet.public-east-1b-subnet-2.id
}

output "private-east-1a_subnet_3_id" {
  description = "Private - Subnet 3 AZ-1a ID"
  value       = aws_subnet.private-east-1a-subnet-3.id
}

output "private-east-1b_subnet_4_id" {
  description = "Private - Subnet 4 AZ-1b ID"
  value       = aws_subnet.private-east-1b-subnet-4.id
}

output "public_subnets" {
  description = "Public Subnets in us-east"
  value       = aws_subnet.private-east-1b-subnet-4.id
}