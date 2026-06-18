##################### SSM Policy #####################

#  Defining trust policy allowing ec2 instance to assume
#  the role.
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

#  Creating role.
resource "aws_iam_role" "ssm_role" {
  name               = "ssm-managed-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

#  Attaching the policy to the role.
resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Making instance profile. This is needed so it can be 
# attached to the ec2 instances. 
resource "aws_iam_instance_profile" "ssm_profile" {
  name = "ssm-instance-profile"
  role = aws_iam_role.ssm_role.name
}

######################################################