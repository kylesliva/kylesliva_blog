terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-east-2"
}

resource "aws_instance" "test_server" {
    ami = "ami-002068ed284fb165b"
    instance_type = "t3a.nano"
    tags = {
        Name = var.server_name
    }
    subnet_id = var.subnet
}