locals {
  container_defintions = [
    #{
    #  name  = "traefik"
    #  image = "traefik:v2.10.1"
    #  cpu       = 500
    #  memory    = 1024 # 1 GB RAM, which is what a t2.micro has
    #  memoryReservation = 256
    #  essential = true
    #  hostname = "traefik",
    #  portMappings = [
    #    {
    #      containerPort = 80
    #      hostPort      = 80
    #    },
    #    {
    #      containerPort = 443
    #      hostPort      = 443
    #    },
    #  ],
    #  environment = jsonencode([
    #    {
    #      "name": "CF_API_EMAIL",
    #      "value": var.cloudflare_api_email
    #    },
    #    {
    #      "name": "CF_API_KEY",
    #      "value": var.cloudflare_api_key
    #    },
    #    {
    #      "name": "PUBLIC_HOSTNAME",
    #      "value": var.public_hostname
    #    }
    #  ]),
    #  dockerLabels =  {
    #    "traefik.enable": true,
    #    "traefik.http.middlewares.sslheader.headers.customrequestheaders.X-Forwarded-Proto": "https",
    #    "traefik.http.middlewares.traefik-auth.basicauth.usersfile": "/usersfile.txt",
    #    "traefik.http.middlewares.traefik-https-redirect.redirectscheme.scheme": "https",
    #    "traefik.http.routers.traefik-secure.entrypoints": "https",
    #    "traefik.http.routers.traefik-secure.middlewares": "traefik-auth,secured@file",
    #    "traefik.http.routers.traefik-secure.rule": "Host(`traefik.${var.public_hostname}`)",
    #    "traefik.http.routers.traefik-secure.service": "api@internal",
    #    "traefik.http.routers.traefik-secure.tls": "true",
    #    "traefik.http.routers.traefik-secure.tls.certresolver": "cloudflare",
    #    "traefik.http.routers.traefik-secure.tls.domains[0].main": "${var.public_hostname}",
    #    "traefik.http.routers.traefik-secure.tls.domains[0].sans": "*.${var.public_hostname}",
    #    "traefik.http.routers.traefik.entrypoints": "http",
    #    "traefik.http.routers.traefik.middlewares": "traefik-https-redirect,secured@file",
    #    "traefik.http.routers.traefik.rule": "Host(`traefik.${var.public_hostname}`)"                                                                      },
    #},
    {
      name     = "leantime_db"
      image    = "mysql:8.0"
      hostname = "leantime_db",
      dependsOn = [
        {
          containerName = "traefik",
          condition     = "START"
        }
      ]
      #cpu       = 10
      memory            = 1024 # 1 GB RAM, which is what a t2.micro has
      memoryReservation = 256
      essential         = true
      environment       = var.env_database
    },
    {
      name     = "leantime"
      image    = "leantime/leantime:2.4"
      hostname = "leantime",
      dependsOn = [
        {
          containerName = "leantime_db",
          condition     = "START"
        }
      ]
      #cpu       = 2
      memory            = 1024 # 1 GB RAM, which is what a t2.micro has
      memoryReservation = 256
      essential         = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      environment = var.env_leantime
    }
  ]

  volumes = [
    {
      "host_path" : "/etc/localtime"
      "name" : "EtcLocaltime"
    },
    {
      "host_path" : "/var/run/docker.sock"
      "name" : "VarRunDocker_Sock"
    },
  ]
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.project_name
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = var.project_name                                                                                            # Name your task
  container_definitions    = length(var.container_definitions) > 0 ? var.container_definitions : jsonencode(local.container_definitions) # List of images for the container
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  requires_compatibilities = ["EC2"] # Can only do EC2 or Fargate, but Fargate has no free tier

  dynamic "volume" {
    for_each = length(var.volumes) > 0 ? var.volumes : local.volumes
    content {
      host_path = volume.value["host"]
      name      = volume.value["name"]
    }
  }

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
