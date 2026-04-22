### variables.tf ###

variable "aws_region" {
    description = "aws region to deploy resources"
    type = string
    default = "ap-south-1"  
}

variable "vpc_cidr" {
    description = "CIDR block for the VPC"
    type = string
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
    description = "CIDR block for the public subnet"
    type = string
    default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
    description = "CIDR block for the private subnet"
    type = string
    default = "10.0.2.0/24"
}

variable "ami_id" {
    description = "AMI ID for EC2 instance"
    type = string
    default = "ami-070e5bd3ff10324f8" # Ubuntu Server 22.04
}

variable "instance_type" {
    description = "EC2 instance type"
    type = string
    default = "t2.micro"
}

variable "key_name" {
    description = "Name of the existing EC2 Key Pair to allow SSH access to the instance"
    type = string
    default = "my-key-pair" # Replace with your actual key pair name
  
}

variable "db_name" {
    description = "Name of the RDS database"
    type = string
    default = "mydb"
}

variable "db_username" {
    description = "Username for RDS database"
    type = string
}

variable "db_password" {
    description = "Password for RDS database"
    type = string
    sensitive = true
}