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

resource "aws_instance" "blog_server" {
    ami = "ami-002068ed284fb165b"
    instance_type = "t3a.micro"
    tags = {
        Name = var.server_name
        blog = "true"
    }
    subnet_id = var.subnet
    key_name = var.keypair
    associate_public_ip_address = "true"
    vpc_security_group_ids = [
        aws_security_group.webports.id,
        var.mgmtsg
    ]
}

resource "aws_s3_bucket" "s3_bucket" {
    bucket = "kylesliva-blog-resources"
    acl = "public-read"
     server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm = "aws:kms"
                kms_master_key_id = aws_kms_key.s3_kms.arn
            }
        }
    }
}

resource aws_kms_key "s3_kms" {
    description = "KMS key for personal blog site's S3 bucket"
    enable_key_rotation = "true"
}

resource "aws_security_group" "webports" {
    name = "webaccess"
    description = "Allow traffic on port 4000/tcp"
    vpc_id = var.webvpc
    ingress {
        description = "port 4000 ingress"
        from_port = 4000
        to_port = 4000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}