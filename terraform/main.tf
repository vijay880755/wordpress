terraform {
  required_version = ">= 0.12.2"
  required_providers {
    aws = ">= 2.42"
  }
}

provider "aws" {
  region  = "ap-south-1"
}

resource "aws_ecs_cluster" "wordpress_cluster" {
  name = var.name
  capacity_providers = ["FARGATE"]
  tags = {
    env = "Development"
    purpose = "From Terraform Cluster"
  }
}

