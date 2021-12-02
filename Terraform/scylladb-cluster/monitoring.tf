resource "aws_instance" "scylla_monitoring" {
  ami                         = var.monitoring_ami
  instance_type               = var.monitoring_instance_type
  availability_zone           = var.azs[0]
  subnet_id                   = var.public_subnet_ids[0]
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.scylla_bastion.id]
  ebs_optimized               = true
  associate_public_ip_address = true
}

resource "aws_ebs_volume" "scylla_monitoring_data" {
  availability_zone = var.azs[0]
  size              = 200
  type              = "gp3"
}

resource "aws_volume_attachment" "scylla_monitoring_data" {
  device_name = "/dev/xvdb"
  instance_id = aws_instance.scylla_monitoring.id
  volume_id   = aws_ebs_volume.scylla_monitoring_data.id
}


resource "aws_security_group" "scylla_bastion" {
  name   = "${var.name}-scylla-bastion"
  vpc_id = var.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}