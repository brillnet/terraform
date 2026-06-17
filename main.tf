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
  ssm_profile_name = module.iam_policies.ssm_profile_name
  public_east_1a_subnet_1_id = module.vpc.public_east-1a_subnet_1_id
  private_east_1a_subnet_2_id = module.vpc.private-east-1a_subnet_2_id
  private_east_1b_subnet_3_id = module.vpc.private-east-1b_subnet_3_id
}

module "dns" {
  source = "./modules/dns"
  depends_on = [module.iam_policies,module.ec2]
  aws_vpc_id = module.vpc.aws_vpc_id
  instance_one_private_ip = module.ec2.instance_one_private_ip
}