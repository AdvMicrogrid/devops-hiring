resource "aws_security_group" "scylla_client" {
  name   = "${var.name}-scylla-client"
  vpc_id = var.vpc_id
}

resource "aws_security_group" "scylla_private" {
  vpc_id = var.vpc_id
}

resource "aws_security_group" "scylla_node" {
  name   = "${var.name}-scylla-node"
  vpc_id = var.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    security_groups = [aws_security_group.scylla_bastion.id]
  }

  ingress {
    from_port   = 9042
    to_port     = 9042
    protocol    = "tcp"
    cidr_blocks = var.allowed_client_cidrs
    security_groups = [aws_security_group.scylla_client.id]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port   = 65500
    protocol  = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
}

