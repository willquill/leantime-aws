# General variables
variable "project_name" {
  type    = string
  default = "leantime-aws"
}

variable "default_tags" {
  type    = map(any)
  default = null
}

# VPC variables
variable "vpc_name" {
  type    = string
  default = ""
}

variable "vpc_cidr" {
  type    = string
  default = "10.100.0.0/16"
}

variable "vpc_region" {
  type    = string
  default = "us-east-2"
}

variable "vpc_subnets" {
  description = "Define your VPC Subnets with AZs"
  type = map(object({
    availability_zone   = string
    private_subnet_cidr = string
    public_subnet_cidr  = string
  }))
  default = {
    az1 = {
      availability_zone   = "us-east-2a"
      private_subnet_cidr = ""                # "10.100.0.0/18" # 16382 hosts
      public_subnet_cidr  = "10.100.192.0/20" # 4094 hosts
    },
    az2 = {
      availability_zone   = "us-east-2b"
      private_subnet_cidr = ""                # "10.100.64.0/18"  # 16382 hosts
      public_subnet_cidr  = "10.100.208.0/20" # 4094 hosts
    },
    az3 = {
      availability_zone   = "us-east-2c"
      private_subnet_cidr = ""                # "10.100.128.0/18" # 16382 hosts
      public_subnet_cidr  = "10.100.224.0/20" # 4094 hosts
    }
  }
}

# ECS variables
variable "container_definitions" {
  description = "List of object maps for the services you want to deploy to the container"
  type = list(object({
    name      = optional(string, "")
    image     = optional(string, "")
    essential = optional(bool, false)
    portmappings = optional(list(object({
      containerport = number
      hostport      = number
    })))
    memory = optional(number, 512)
    cpu    = optional(number, null)
  }))
  default = []
}

# Cloudwatch variables
variable "alert_dollar_threshold" {
  type    = string
  default = "1"
}

variable "alert_email_address" {
  type    = string
  default = ""
}

variable "vpc_enable_nat_gateway" {
  type    = bool
  default = false
}

variable "vpc_enable_vpn_gateway" {
  type    = bool
  default = false
}

variable "media_request_database_type" {
  description = "The type of DB for Ombi. Can be either 'sqlite' or 'mariadb'."
  type        = string
  default     = "mariadb"
}

variable "media_request_database_size" {
  description = "The DB instance size if 'media_request_database_type' is set to 'mariadb'."
  type        = string
  default     = "db.t4g.micro"
}

variable "cloudwatch_enable" {
  type    = bool
  default = false
}
