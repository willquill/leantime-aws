# General variables
variable "project_name" {
  type    = string
  default = "leantime"
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

# RDS variables

variable "rds" {
  description = "RDS module inputs"
  type = object({
    engine               = optional(string, "mariadb")
    engine_version       = optional(string, "10.11.5")
    major_engine_version = optional(string, "10.11")
    instance_class       = optional(string, "db.t4g.micro")
    username             = optional(string, "leantime")
    port                 = optional(string, "3306")
    maintenance_window   = optional(string, "Mon:00:00-Mon:03:00")
    backup_window        = optional(string, "03:00-06:00")
    family               = optional(string, "mariadb10.11")
  })
  default = {
    engine               = "mariadb"
    engine_version       = "10.11.5"
    major_engine_version = "10.11"
    instance_class       = "db.t4g.micro"
    username             = "leantime"
    port                 = "3306"
    maintenance_window   = "Mon:00:00-Mon:03:00"
    backup_window        = "03:00-06:00"
    family               = "mariadb10.11"
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
    memory       = optional(number, 512)
    cpu          = optional(number, null)
    dockerLabels = optional(map(any))
  }))
  default = []
}

variable "volumes" {
  description = "Docker volumes"
  type        = list(any)
  default     = []
}

variable "cloudflare_api_email" {
  description = "Email used to access Cloudflare API"
  type        = string
  default     = ""
}

variable "cloudflare_api_key" {
  description = "API key used to access Cloudflare"
  type        = string
  default     = ""
}

variable "public_hostname" {
  description = "public hostname for the containers"
  type        = string
  default     = ""
}

# MySQL variables


variable "env_database" {
  description = "List of object maps for the database container environment variables"
  type = list(object({
    name  = optional(string, "")
    value = optional(string, "")
  }))
  default = [
    {
      name  = "MYSQL_ROOT_PASSWORD"
      value = "changeme123!"
    },
    {
      name  = "MYSQL_DATABASE"
      value = "leantime"
    },
    {
      name  = "MYSQL_USER"
      value = "lean"
    },
    {
      name  = "MYSQL_PASSWORD"
      value = "changeme123!"
    }
  ]
}

variable "env_leantime" {
  description = "List of object maps for the leantime container environment variables"
  type = list(object({
    name  = optional(string, "")
    value = optional(string, "")
  }))
  default = [
    {
      name  = "LEAN_DB_HOST"
      value = "leantime_db"
    },
    {
      name  = "LEAN_DB_DATABASE"
      value = "leantime"
    },
    {
      name  = "LEAN_DB_USER"
      value = "leantime"
    },
    {
      name  = "LEAN_DB_PASSWORD"
      value = "changeme123!"
    },
    {
      name  = "LEAN_DB_PORT"
      value = 3306
    }
  ]
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
  default = true
}
