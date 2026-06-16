output "subnet_1_id" {
  description = "Subnet 1 ID"
  value       = module.vpc.subnet_1_id
}

output "subnet_2_id" {
  description = "Subnet 2 ID"
  value       = module.vpc.subnet_2_id
}

output "subnet_3_id" {
  description = "Subnet 3 ID"
  value       = module.vpc.subnet_3_id
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