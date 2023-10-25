# I'm using Parameter Store to obfuscate
# certain values for my own privacy.
# This section assumes that the parameters have
# already been setup in AWS Parameter Store
# and are using appropriate values.

data "aws_caller_identity" "current" {}

data "aws_ssm_parameter" "rds_password" {
  name = "/${lower(var.project_name)}/terraform/rds-password"
}
