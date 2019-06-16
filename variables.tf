variable "aws_profile" {}

variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "eu-west-1"
}

variable "amis" {
    description = "AMIs by region"
    default = {
        eu-west-1 = "ami-f1810f86" # ubuntu 14.04 LTS
    }
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
    description = "CIDR for the Public Subnet"
    default = "10.0.0.0/24"
}

variable "private_web_subnet_cidr" {
    description = "CIDR for the Private Web Subnet"
    default = "10.0.1.0/24"
}


variable "private_jenkins_subnet_cidr" {
    description = "CIDR for the Private Jenkins Subnet"
    default = "10.0.2.0/24"
}

variable "web_instance_count" {
  default = "0"
}

variable "jenkins_instance_count" {
  default = "1"
}

variable "aws_availability_zone" {
    description = "EC2 Zone for the VPC"
    default = "eu-west-1a"
}
