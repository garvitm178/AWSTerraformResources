terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

module "ec2_instance" {
  source         = "./EC2Module"
  ami_id         = "ami-022e1a32d3f742bd8"
  instance_type  = "t2.micro"
  instance_count = 2
  key_name       = "jenkins"
  tags = {
    Name = "MyInstance"
  }
  aws_access_key = "******************"
  aws_secret_key = "****************************"

}
