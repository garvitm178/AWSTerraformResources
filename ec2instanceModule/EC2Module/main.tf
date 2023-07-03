terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}


#VARIABLE BLOCKS
variable "ami_id" {
  description = "The AMI ID"
  type        = string
}

variable "instance_type" {
  description = "The EC2 instance type"
  type        = string
}

variable "tags" {
  description = "Tags for the EC2 instance"
  type        = map(string)
}

variable "instance_count" {
  description = "The number of EC2 instances to be created"
  type        = number
}

variable "key_name" {
  description = "The name of the SSH key pair"
  type        = string
}

variable "open_ports" {
  description = "List of open ports to allow"
  type        = list(number)
}

variable "cidr_blocks" {
  description = "List of CIDR blocks to allow access from"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "aws_access_key" {
  description = "access key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "secret key"
  type        = string
  sensitive   = true
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = "us-east-1"
}

#RESOURCE BLOCKS

resource "aws_security_group" "aws_sg" {
  name        = "security_group_vam"
  description = "Security group"

  dynamic "ingress" {
    for_each = var.open_ports
    content {
      from_port   = ingress.each.value
      to_port     = ingress.each.value
      protocol    = "tcp"
      cidr_blocks = var.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.aws_sg.id]
  tags                   = var.tags
  count                  = var.instance_count
}

#OUTPUT VALUES

output "instance_ip_addr" {
  value = aws_instance.example.*.private_ip
}