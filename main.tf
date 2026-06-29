# Configure the AWS Provider
provider "aws" {
  region     = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

module "vpc" {
  source      = "./modules/vpc"
}

module "iam_policies" {
  source = "./modules/iam_policies"
}

module "ec2" {
  source = "./modules/ec2"
  depends_on = [module.iam_policies]
  aws_security_group_allow_web_id = module.vpc.aws_security_group_allow_web_id
  aws_security_group_allow_icmp_id = module.vpc.aws_security_group_allow_icmp_id
  aws_security_group_allow_outbound_id = module.vpc.aws_security_group_allow_outbound_id
  aws_security_group_allow_ssm_id = module.vpc.aws_security_group_allow_ssm_id
  ssm_profile_name = module.iam_policies.ssm_profile_name
  public_east_1a_subnet_1_id = module.vpc.public_east-1a_subnet_1_id

  public_east_1b_subnet_2_id = module.vpc.public_east-1b_subnet_2_id


  private_east_1a_subnet_3_id = module.vpc.private-east-1a_subnet_3_id
  private_east_1b_subnet_4_id = module.vpc.private-east-1b_subnet_4_id
}

# "public_east-1a_subnet_1_id"
# "public_east-1b_subnet_2_id"


module "load_balancer" {
  source = "./modules/load_balancer"
  depends_on = [module.ec2]
  aws_vpc_id = module.vpc.aws_vpc_id
  public_subnet_ids = [
    module.vpc.public_east-1a_subnet_1_id,
    module.vpc.public_east-1b_subnet_2_id
  ]
  private_server_one_id = module.ec2.instance_id_one
  private_server_two_id = module.ec2.instance_id_two
  security_groups = [module.vpc.aws_security_group_allow_web_id]
}

# module "dns" {
#   source = "./modules/dns"
#   depends_on = [module.iam_policies,module.ec2]
#   aws_vpc_id = module.vpc.aws_vpc_id
#   instance_one_private_ip = module.ec2.instance_one_private_ip
# }