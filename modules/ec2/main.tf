#  Creating private instance one
resource "aws_instance" "private-server-one" {
  ami           = "ami-098e39bafa7e7303d"
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  iam_instance_profile = var.ssm_profile_name
  #  Adding user data script to install sample webserver
  user_data = file("${path.module}/webserver.sh")
  vpc_security_group_ids = [var.aws_security_group_allow_web_id,
  var.aws_security_group_allow_outbound_id,
  var.aws_security_group_allow_ssm_id,
  var.aws_security_group_allow_icmp_id]

  # Attaching instance to a specific subnet_2
  subnet_id = var.private_east_1a_subnet_3_id

  tags = {
    Name = "vm_instance_two"
  }
}

#  Creating private instance two.
resource "aws_instance" "private-server-two" {
  ami           = "ami-098e39bafa7e7303d"
  instance_type = "t2.micro"
  availability_zone = "us-east-1b"
  iam_instance_profile = var.ssm_profile_name
  user_data = file("${path.module}/webserver.sh")
  vpc_security_group_ids = [var.aws_security_group_allow_web_id,
  var.aws_security_group_allow_outbound_id,
  var.aws_security_group_allow_ssm_id,
  var.aws_security_group_allow_icmp_id]

  # Attaching instance to a specific subnet_3
  subnet_id = var.private_east_1b_subnet_4_id

  tags = {
    Name = "vm_instance_three"
  }
}
