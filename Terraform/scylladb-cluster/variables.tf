variable "name" {
  type = string
}

variable "product" {
  type = string
  default = ""
}

variable "env" {
  type = string
  default = ""
}

variable "node_count" {
  type = string
}

variable "allowed_client_cidrs" {
  type    = list(string)
  default = []
}

variable "instance_type" {
  type    = string
  default = "i3.xlarge"
}

variable "monitoring_instance_type" {
  type    = string
  default = "t3.xlarge"
}

variable "key_name" {
  type    = string
  default = "admin"
}

variable "amis" {
  type = list(string)
}

variable "monitoring_ami" {
  type    = string
  default = "ami-3ecc8f46"
}

variable "azs" {
  type = list(string)
  default = [
    "us-west-2a",
    "us-west-2b",
    "us-west-2c",
  ]
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "monitoring_app_port" {
  type    = string
  default = 3000
}

variable "monitoring_external_port" {
  type    = string
  default = 443
}

variable "monitoring_external" {
  type    = string
  default = "0"
}

variable "monitoring_external_allowed_cidrs" {
  type    = list(string)
  default = []
}

variable "backup_bucket_expiration" {
  type    = string
  default = 7
}

variable "extra_backup_buckets" {
  type    = list(string)
  default = []
}

variable "cluster_user_data" {
  type    = string
  default = <<EOF
{
"scylla_yaml": {
  "experimental": false
  },
  "start_scylla_on_first_boot": false
}
EOF

}

