// Creating VPC
resource "aws_vpc" "qbd" {
  cidr_block = "10.10.0.0/16"
  tags = {
    Name = "qbd"
  }
}

// Internet Gateway
resource "aws_internet_gateway" "qbd-igw" {
  vpc_id = "${aws_vpc.qbd.id}"
  tags = {
    Name = "qbd-igw"
  }
}

// Elastic IP

resource "aws_eip" "eip" {
  vpc = true
}


data "aws_availability_zones" "azs" {
  state = "available"
}

// creating public subnet
resource "aws_subnet" "public-subnet" {
  availability_zone       = "${data.aws_availability_zones.azs.names[0]}"
  cidr_block              = "10.10.20.0/24"
  vpc_id                  = "${aws_vpc.qbd.id}"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "public-subnet"
  }
}

// Create private subnet
resource "aws_subnet" "private-subnet" {
  availability_zone = "${data.aws_availability_zones.azs.names[0]}"
  cidr_block        = "10.10.30.0/24"
  vpc_id            = "${aws_vpc.qbd.id}"
  tags = {
    Name = "private-subnet"
  }
}

// Create NAT Gateway
resource "aws_nat_gateway" "qbd-ngw" {
  allocation_id = "${aws_eip.eip.id}"
  subnet_id     = "${aws_subnet.private-subnet.id}"
  tags = {
    Name = "QBD Nat Gateway"
  }
}

//  Create Routing table
resource "aws_route_table" "qbd-public-route" {
  vpc_id = "${aws_vpc.qbd.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.qbd-igw.id}"
  }
  tags = {
    Name = "qbd-public-route"
  }
}

resource "aws_default_route_table" "qbd-default-route" {
  default_route_table_id = "${aws_vpc.qbd.default_route_table_id}"
  tags = {
    Name = "qbd-default-route"
  }
}


// Associate subnet
resource "aws_route_table_association" "arts" {
  subnet_id      = "${aws_subnet.public-subnet.id}"
  route_table_id = "${aws_route_table.qbd-public-route.id}"
}

resource "aws_route_table_association" "arts-p" {
  subnet_id      = "${aws_subnet.private-subnet.id}"
  route_table_id = "${aws_vpc.qbd.default_route_table_id}"
}


# Define the security group for public subnet
// resource "aws_security_group" "sgweb" {
//   name        = "vpc_qbd_web"
//   description = "Allow incoming HTTP connections & SSH access"

//   ingress {
//     from_port   = 80
//     to_port     = 80
//     protocol    = "tcp"
//     cidr_blocks = ["0.0.0.0/0"]
//   }

//   ingress {
//     from_port   = 443
//     to_port     = 443
//     protocol    = "tcp"
//     cidr_blocks = ["0.0.0.0/0"]
//   }

//   ingress {
//     from_port   = -1
//     to_port     = -1
//     protocol    = "icmp"
//     cidr_blocks = ["0.0.0.0/0"]
//   }

//   ingress {
//     from_port   = 22
//     to_port     = 22
//     protocol    = "tcp"
//     cidr_blocks = ["0.0.0.0/0"]
//   }
//   egress {
//     from_port   = 0
//     to_port     = 0
//     protocol    = "-1"
//     cidr_blocks = ["0.0.0.0/0"]
//   }

//   vpc_id = "${aws_vpc.qbd.id}"

//   tags = {
//     Name = "Web Server SG"
//   }
// }

# Define the security group for private subnet
resource "aws_security_group" "sgweb" {
  name        = "vpc_qbd_web"
  description = "Allow traffic from public subnet"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }

  vpc_id = "${aws_vpc.qbd.id}"

  tags = {
    Name = "DB SG"
  }
}
