module "sg_host_inbound_web" {
  source  = "terraform-aws-modules/security-group/aws"
  version = ">= 5.1"

  name        = "${var.project_name}-web-inbound"
  description = "Security group to allow inbound web traffic"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "Allow inbound HTTP"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "Allow inbound HTTPS"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_rules = ["all-all"]

  tags = {
    Usage = "Inbound web traffic for ${var.project_name}"
  }
}

module "sg_maria_db_rds" {
  source  = "terraform-aws-modules/security-group/aws"
  version = ">= 5.1"

  name        = "${var.project_name}-mariadb-rds"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = module.vpc.public_subnets_cidr_blocks

  ingress_with_cidr_blocks = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "Mariadb Access from within the VPC"
    }
  ]

  egress_rules = ["all-all"]

  tags = {
    Usage = "Allow access to mariadb RDS"
  }
}
