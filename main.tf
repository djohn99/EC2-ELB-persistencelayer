resource "aws_launch_configuration" "wb_launch_conf" {
  name            = "web_config"
  image_id        = "${var.ami-id}"
  instance_type   = "${var.instance_type}"
  key_name        = "${var.key_name}"
  security_groups = ["${aws_security_group.sgweb.id}"]
  user_data       = "userdata.sh"

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 30
    delete_on_termination = false
  }

  lifecycle {
    create_before_destroy = true
  }
}