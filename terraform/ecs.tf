resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.project_name
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = var.project_name                      # Name your task
  container_definitions    = jsonencode(var.container_definitions) # List of images for the container
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  requires_compatibilities = ["EC2"] # Can only do EC2 or Fargate, but Fargate has no free tier

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.instance-type in [t2.micro]" # Limit to free tier instance types
  }
}

#resource "aws_ecs_service" "service" {
#  name            = var.project_name
#  cluster         = aws_ecs_cluster.ecs_cluster.id
#  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
#  desired_count = 1
#
#  #network_configuration {
#  #  subnets = [aws_subnet.subnet.id, aws_subnet.subnet2.id]
#  #  security_groups = [aws_security_group.security_group.id]
#  #}
#}