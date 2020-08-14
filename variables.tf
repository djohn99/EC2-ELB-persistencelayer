variable "aws_region" {
  default = "us-east-1"
}

variable "ami" {
  description = "Amazon Linux AMI"
  default     = "ami-14c5486b"
}

variable "vpc_cidr" {
  default = "10.10.0.0/16"
}

variable "vpc_private_subnets" {
  description = "List of VPC private subnets"
  type        = list
  default     = ["subnet-0df023f3078c78028"]
}

variable "vpc_public_subnets" {
  description = "List of VPC Public subnets"
  type        = list
  default     = ["subnet-5803cb15"]
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  default     = "10.10.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the private subnet"
  default     = "10.10.2.0/24"
}

variable "key_name" {
  description = "SSH KeyPair"
  default     = "openshift-aws"
}

variable "instance_type" {
  description = "instance type using "
  default     = "t3.medium"
}

variable "ami-id" {
  description = "ami id to use"
  default     = "ami-09d8b5222f2b93bf0"
}