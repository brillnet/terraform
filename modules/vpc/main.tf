#  Creating vpc
resource "aws_vpc" "prod-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "production"
  }
  enable_dns_support   = true
  enable_dns_hostnames = true 

}

#  Creating internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.prod-vpc.id
}


#  Setting up security groups.

#  Needed for all outbound connectivity
resource "aws_security_group" "outbound" {
  name        = "outbound-sg"
  description = "Security group with outbound to all"
  vpc_id      = aws_vpc.prod-vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

#  Needed for icmp connectivity
resource "aws_vpc_security_group_ingress_rule" "allow_icmp_ipv4" {
  security_group_id = aws_security_group.allow_icmp.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = -1
  to_port           = -1
  ip_protocol       = "icmp"
}

resource "aws_security_group" "allow_icmp" {
  name        = "allow_icmp traffic"
  description = "Allow icmp inbound traffic"
  vpc_id      = aws_vpc.prod-vpc.id

  tags = {
    Name = "allow_icmp"
  }
}

#  Needed for SSM
resource "aws_security_group" "ssm" {
  name        = "ssm-sg"
  description = "Security group with outbound HTTPS"
  vpc_id      = aws_vpc.prod-vpc.id

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh traffic"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.prod-vpc.id

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  # cidr_ipv4         = "18.206.107.24/29"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_security_group" "efs_sg" {
  name   = "efs-server-sg"
  vpc_id = aws_vpc.prod-vpc.id

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    # Reference the ID of the load balancer SG here
    security_groups = [aws_security_group.allow_ssh.id]
  }
}

#  Creating route table for prod us-east-1a
resource "aws_route_table" "prod-route-table-public-east-1" {
  vpc_id = aws_vpc.prod-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Public Route Table - east-1"
  }
}

#  Allocating EIP. This will be used for the NAT GW
resource "aws_eip" "nat_gw_eip" {
  domain = "vpc"
  tags = {
    Name = "NAT_GW-EIP"
  }
}

#  Create public subnet in us-east-1a
resource "aws_subnet" "public-east-1a-subnet-1" {
  vpc_id = aws_vpc.prod-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Public Subnet AZ A"
  }
}

#  Create public subnet in us-east-1b
resource "aws_subnet" "public-east-1b-subnet-2" {
  vpc_id = aws_vpc.prod-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Public Subnet AZ B"
  }
}

#  Creating NAT GW. This will be used in the private subnet
#  routing table.
resource "aws_nat_gateway" "nat_gw_for_private" {
  allocation_id = aws_eip.nat_gw_eip.id
  subnet_id     = aws_subnet.public-east-1a-subnet-1.id

  tags = {
    Name = "gw NAT"
  }

  #  Adding depends for the internet gateway.
  depends_on = [aws_internet_gateway.gw]
}


#  Creating private subnet in us-east-1a
resource "aws_subnet" "private-east-1a-subnet-3" {
  vpc_id = aws_vpc.prod-vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Private Subnet 3 AZ A"
  }
}

#  Creating private subnet in us-east-1b
resource "aws_subnet" "private-east-1b-subnet-4" {
  vpc_id = aws_vpc.prod-vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Private Subnet 4 AZ B"
  }
}

#  Creating private route table for prod us-east-1a
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.prod-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw_for_private.id
    # gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Private Route Table"
  }
}

#  Associating public subnet in us-east-1a with route table.
resource "aws_route_table_association" "public_assoc_one" {
  subnet_id = aws_subnet.public-east-1a-subnet-1.id
  route_table_id = aws_route_table.prod-route-table-public-east-1.id
}

#  Associating public subnet in us-east-1b with route table.
resource "aws_route_table_association" "public_assoc_two" {
  subnet_id = aws_subnet.public-east-1b-subnet-2.id
  route_table_id = aws_route_table.prod-route-table-public-east-1.id
}

#  Associating private subnet in us-east-1a with route table.
resource "aws_route_table_association" "private_assoc" {
  subnet_id = aws_subnet.private-east-1a-subnet-3.id
  route_table_id = aws_route_table.private-route-table.id
}

#  Associating private subnet in us-east-1b with route table.
resource "aws_route_table_association" "private_assoc_two" {
  subnet_id = aws_subnet.private-east-1b-subnet-4.id
  route_table_id = aws_route_table.private-route-table.id
}
