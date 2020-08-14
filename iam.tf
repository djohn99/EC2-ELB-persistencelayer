resource "aws_iam_role" "qbd_role" {
  name = "qbd_role"

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

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_instance_profile" "qbd_profile" {
  name = "qbd_profile"
  role = "${aws_iam_role.qbd_role.name}"
}

resource "aws_iam_role_policy" "qbd_policy" {
  name = "qbd_policy"
  role = "${aws_iam_role.qbd_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}