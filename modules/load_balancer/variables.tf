variable "aws_vpc_id" {
  type        = string
  description = "vpc id"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "public subnet ids"
}

variable "security_groups" {
  type        = list
  description = "security groups for load balancer"
}

variable "private_server_one_id" {
  type = string
  description = "ec2 instance_one id"
}

variable "private_server_two_id" {
  type = string
  description = "ec2 instance_two id"
}