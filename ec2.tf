# Define webserver inside the public subnet
resource "aws_instance" "wb" {
  ami                         = "${var.ami}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_name}"
  subnet_id                   = "${aws_subnet.private-subnet.id}"
  vpc_security_group_ids      = ["${aws_security_group.sgweb.id}"]
  iam_instance_profile        = "${aws_iam_instance_profile.qbd_profile.name}"
  associate_public_ip_address = true
  source_dest_check           = false
  user_data                   = "userdata.sh"

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 30
    delete_on_termination = false
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "webserver"
  }
}