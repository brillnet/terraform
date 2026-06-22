variable "public_east_1a_subnet_1_id" {
  type        = string
  description = "Subnet 1 id"
}

variable "private_east_1a_subnet_3_id" {
  type        = string
  description = "Subnet 2 id"
}

variable "private_east_1b_subnet_4_id" {
  type        = string
  description = "Subnet 3 id"
}

variable "ssm_profile_name" {
  type        = string
  description = "ssm profile name"
}

variable "aws_security_group_allow_web_id" {
  type        = string
  description = "aws security group allow web"
}

variable "aws_security_group_allow_outbound_id" {
  type        = string
  description = "Outbound access"
}

variable "aws_security_group_allow_icmp_id" {
  type        = string
  description = "Allow ICMP outbound"
}
