#  Creating private instance one
resource "aws_instance" "private-server-one" {
  ami           = "ami-098e39bafa7e7303d"
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  iam_instance_profile = var.ssm_profile_name
  # vpc_security_group_ids = [aws_security_group.allow_ssh.id,
  # aws_security_group.outbound.id,aws_security_group.allow_icmp.id]

  # Attaching instance to a specific subnet_2
  subnet_id = var.subnet_2_id

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
  # vpc_security_group_ids = [aws_security_group.allow_ssh.id,
  # aws_security_group.outbound.id,aws_security_group.allow_icmp.id]

  # Attaching instance to a specific subnet_3
  subnet_id = var.subnet_3_id

  tags = {
    Name = "vm_instance_three"
  }
}
