terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.75.0"
    }
  }
  required_version = "~> 1.0"
}

provider "aws" {
  region = "us-east-2"
}

module "bootstrap" {
  source        = "trussworks/bootstrap/aws"
  version       = "~> 5.1.0"
  region        = "us-east-2"
  account_alias = "leantime"
}
