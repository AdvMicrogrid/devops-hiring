resource "aws_iam_instance_profile" "node" {
  name = "${var.name}-scylla-cluster-node-profile"
  role = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node_backups" {
  role       = aws_iam_role.node.name
  policy_arn = aws_iam_policy.node_backups.arn
}

resource "aws_iam_role" "node" {
  name               = "${var.name}-scylla-cluster-node"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_policy" "node_backups" {
  name   = "${var.name}-scylla-backups"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowSeeBackupsBucket",
            "Effect":"Allow",
            "Action":[
               "s3:ListBucket",
               "s3:GetBucketLocation"
            ],
            "Resource": "arn:aws:s3:::${aws_s3_bucket.backups.bucket}"
        },
        {
            "Sid": "AllowToGetBackups",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:GetObjectAcl",
                "s3:PutObject",
                "s3:PutObjectAcl"
            ],
            "Resource": "arn:aws:s3:::${aws_s3_bucket.backups.bucket}/*"
        }
    ]
}
EOF

}
