#  Outputting instance id of private server one
output "instance_id_one" {
  description = "The ID of the private EC2 instance1 in AZ 1a"
  value       = aws_instance.private-server-one.id
}

#  Outputting Public subnet two
# output "instance_one_private_ip" {
#   description = "Public Subnet Two"
#   value       = aws_instance.private-server-one.private_ip
# }

#  Outputting Private IP address of instance one
output "instance_one_private_ip" {
  description = "The private IP address of the EC2 instance one."
  value       = aws_instance.private-server-one.private_ip
}

#  Outputting instance id of instance two.
output "instance_id_two" {
  description = "The ID of the private EC2 instance1 in AZ 1b"
  value       = aws_instance.private-server-two.id
}

