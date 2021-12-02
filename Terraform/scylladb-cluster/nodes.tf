resource "aws_instance" "node" {
  count                = var.node_count
  ami                  = var.amis[count.index]
  instance_type        = var.instance_type
  availability_zone    = var.azs[0]
  iam_instance_profile = aws_iam_instance_profile.node.name
  key_name             = var.key_name
  subnet_id            = var.private_subnet_ids[0]
  vpc_security_group_ids = [
    aws_security_group.scylla_node.id,
    aws_security_group.scylla_client.id,
    aws_security_group.scylla_private.id,
  ]
  ebs_optimized = true
  user_data = var.cluster_user_data
}

