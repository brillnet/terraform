output "public_east-1a_subnet_1_id" {
  description = "public-east-1a-subnet-1 ID"
  value       = module.vpc.public_east-1a_subnet_1_id
}

output "private-east-1a-subnet_3_id" {
  description = "private-east-1a-subnet-3 ID"
  value       = module.vpc.private-east-1a_subnet_3_id
}

output "private-east-1b_subnet_4_id" {
  description = "Subnet 4 ID"
  value       = module.vpc.private-east-1b_subnet_4_id
}

output "private-server-one-id" {
  description = "ec2 instance_one id"
  value       = module.ec2.instance_id_one
}

output "private-server-one-ip" {
  description = "ec2 instance_one id"
  value       = module.ec2.instance_one_private_ip
}

output "private-server-two" {
  description = "ec2 instance_two id"
  value       = module.ec2.instance_id_two
}