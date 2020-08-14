// ELB
resource "aws_security_group" "elb_qbd_sg" {
  name        = "elb_qbd_sg"
  description = "Allow https traffic"
  vpc_id      = "${aws_vpc.qbd.id}"

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name   = "elb_qbd_sg"
    Author = "djohn"
    Tool   = "Terraform"
  }
}

// QBD ELB
resource "aws_elb" "qbd-elb" {
  subnets                   = ["subnet-065357cc3d6551dad"]
  cross_zone_load_balancing = true
  security_groups           = ["${aws_security_group.elb_qbd_sg.id}"]
  instances                 = ["${aws_instance.wb.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:8080"
    interval            = 5
  }

  tags = {
    Name   = "qbd_elb"
    Author = "djohn"
    Tool   = "Terraform"
  }
}


// resource "aws_elb" "qbd-elb" {
//   name               = "qbd-elb"
//   availability_zones = ["us-east-1a", "us-east-1b"]

//   access_logs {
//     bucket        = "qbd"
//     bucket_prefix = "qbd-elb"
//     interval      = 60
//   }

//   listener {
//     instance_port     = 80
//     instance_protocol = "http"
//     lb_port           = 80
//     lb_protocol       = "http"
//   }

//   health_check {
//     healthy_threshold   = 2
//     unhealthy_threshold = 2
//     timeout             = 3
//     target              = "HTTP:80/"
//     interval            = 30
//   }

//   instances                   = [aws_instance.wb.id]
//   cross_zone_load_balancing   = true
//   idle_timeout                = 400
//   connection_draining         = true
//   connection_draining_timeout = 400

//   tags = {
//     Name = "qbd-elb"
//   }
// }

