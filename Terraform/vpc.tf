# VPC Configuration
resource "aws_vpc" "scylla_vpc" {
  cidr_block         = "10.0.0.0/16"
  enable_dns_support = true
}

resource "aws_subnet" "scylla_public_subnet" {
  vpc_id            = aws_vpc.scylla_vpc.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "us-west-2a"
}

resource "aws_subnet" "scylla_private_subnet" {
  vpc_id            = aws_vpc.scylla_vpc.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "us-west-2a"
}

resource "aws_internet_gateway" "scylla_igw" {
  vpc_id = aws_vpc.scylla_vpc.id
}

resource "aws_route_table" "scylla_route_table" {
  vpc_id = aws_vpc.scylla_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.scylla_igw.id
  }
}

resource "aws_route_table_association" "scylla_route_assoc" {
  subnet_id      = aws_subnet.scylla_public_subnet.id
  route_table_id = aws_route_table.scylla_route_table.id
}

resource "aws_eip" "scylla_eip" {
  vpc = true
}

resource "aws_nat_gateway" "scylla_nat_igw" {
  allocation_id = aws_eip.scylla_eip.id
  subnet_id     = aws_subnet.scylla_public_subnet.id
}

output "scylla_nat_gw_ip" {
  value = aws_eip.scylla_eip.public_ip
}

resource "aws_route_table" "scylla_private_subnet_route_table" {
  vpc_id = aws_vpc.scylla_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.scylla_nat_igw.id
  }
}

resource "aws_route_table_association" "scylla_private_route_table" {
  subnet_id      = aws_subnet.scylla_private_subnet.id
  route_table_id = aws_route_table.scylla_private_subnet_route_table.id
}

resource "aws_security_group" "dev_scylla_sg" {
  name   = "dev-scylla-sg"
  vpc_id = aws_vpc.scylla_vpc.id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}