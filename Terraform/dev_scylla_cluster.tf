variable "scylla_4_4_1_ami" {
  default = "ami-0535c8d7fd3c1754c"
}

module "dev_scylla_cluster" {
  source = "scylladb-cluster"
  name   = "scylla_cluster"
  product = "devops"
  env = "devops-dev"
  amis = [
    var.scylla_4_4_1_ami,
    var.scylla_4_4_1_ami,
    var.scylla_4_4_1_ami,
    var.scylla_4_4_1_ami,
    var.scylla_4_4_1_ami,
    var.scylla_4_4_1_ami,
  ]
  node_count = "5"
  cluster_user_data = <<EOF
{
"scylla_yaml": {
  "cluster_name": "scylla_cluster",
  "experimental": false
  },
  "start_scylla_on_first_boot": false
}
EOF
  vpc_id                            = aws_vpc.scylla_vpc.id
  public_subnet_ids                 = [aws_subnet.scylla_public_subnet.id]
  private_subnet_ids                = [aws_subnet.scylla_private_subnet.id]
  allowed_client_cidrs              = [aws_vpc.scylla_vpc.cidr_block]
  monitoring_external               = true
  monitoring_instance_type          = "t3.xlarge"
  monitoring_external_allowed_cidrs = ["10.0.10.99/32"]
  key_name                          = "super-secret-private.key"
  monitoring_ami                    = "ami-03168x1c4d7b1a8s2"
  extra_backup_buckets              = ["scylla-cluster-backups"]
  backup_bucket_expiration          = 14
  azs                               = ["us-west-2a"]
}




