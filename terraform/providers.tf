terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.45.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.vpc_region

  default_tags {
    tags = local.default_tags
  }
}

locals {
  default_tags = merge(var.default_tags,{Project = var.project_name})
}
