// ASG QBD
resource "aws_autoscaling_group" "qbd-asg" {
  launch_configuration = "${aws_launch_configuration.wb_launch_conf.name}"
  vpc_zone_identifier  = ["subnet-065357cc3d6551dad"]
  // vpc_zone_identifier  = ["var.vpc_private_subnet.default"]
  // associate_public_ip_address  = true
  min_size             = 1
  max_size             = 2

  depends_on = ["aws_instance.wb", "aws_elb.qbd-elb"]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "webserver"
    propagate_at_launch = true
  }

  tag {
    key                 = "Author"
    value               = "djohn"
    propagate_at_launch = true
  }

  tag {
    key                 = "Tool"
    value               = "Terraform"
    propagate_at_launch = true
  }
}


// Scale out
resource "aws_cloudwatch_metric_alarm" "high-cpu-qbd-alarm" {
  alarm_name          = "high-cpu-qbd-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.qbd-asg.name}"
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.scale-out.arn}"]
}

resource "aws_autoscaling_policy" "scale-out" {
  name                   = "scale-out-qbd-wb"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 80
  autoscaling_group_name = "${aws_autoscaling_group.qbd-asg.name}"
}

// Scale In
resource "aws_cloudwatch_metric_alarm" "low-cpu-qbd-alarm" {
  alarm_name          = "low-cpu-qbd-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "20"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.qbd-asg.name}"
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.scale-in.arn}"]
}

resource "aws_autoscaling_policy" "scale-in" {
  name                   = "scale-in-qbd"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = "${aws_autoscaling_group.qbd-asg.name}"
}
