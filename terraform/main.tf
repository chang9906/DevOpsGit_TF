terraform {
  # Provider-specific settings
  required_providers {
    aws = {
      version = ">= 2.7.0"
      source  = "hashicorp/aws"
    }
  }
  backend "s3"{
    key = "aws/ec2-deploy/terraform.tfstate"
    region = "us-east-1"
  }  # Terraform version
}
provider "aws" {
  # This is how we access variables
  region = var.aws_region
}
resource "aws_instance" "server" {
    ami = "ami-080e1f13689e07408"
    instance_type = "t2.micro"
    key_name = aws_key_pair.deployer.key_name
    vpc_security_group_ids = [aws_security_group.SG1.id]
    iam_instance_profile = aws_iam_instance_profile.ec2-profile.name
    connection {
      type = "ssh"
      host = self.public_ip
      user = "ubuntu"
      private_key = var.private_key
      timeout = "4m"
    }
    tags = {
      "name" = "DeployVM"
    }
}
resource "aws_iam_instance_profile" "ec2-profile" {
    name = "ec2-profile"
    role = "EC2-Container"
  
}
resource "aws_security_group" "SG1" {
    egress = [
        {
            cidr_blocks = ["0.0.0.0/0"]
            from_port = 0
            protocol = "-1"
            self = false
            to_port = 0
        }
    ]
    ingress = [
        { #SSH to Instance
            cidr_blocks = ["0.0.0.0/0", ]
            from_port = 22
            protocol = "tcp"
            self = false
            to_port = 22
        },
        { #HTTP
            cidr_blocks = ["0.0.0.0/0", ]
            from_port = 80
            protocol = "tcp"
            self = false
            to_port = 80  
        }
    ]
}
resource "aws_key_pair" "deployer"{
    key_name = var.key_name
    public_key = var.public_key
}