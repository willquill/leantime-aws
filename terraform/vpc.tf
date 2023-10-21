module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = ">= 5.1.2"

  name = var.vpc_name != "" ? var.vpc_name : var.project_name
  cidr = var.vpc_cidr

  azs             = [for az in var.vpc_subnets : az["availability_zone"]]
  private_subnets = [for az in var.vpc_subnets : az["private_subnet_cidr"] if az["private_subnet_cidr"] != ""]
  public_subnets  = [for az in var.vpc_subnets : az["public_subnet_cidr"] if az["public_subnet_cidr"] != ""]

  enable_nat_gateway = var.vpc_enable_nat_gateway
  enable_vpn_gateway = var.vpc_enable_vpn_gateway
}
