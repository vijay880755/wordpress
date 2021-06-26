data "aws_lb_listener" "selected" {
  load_balancer_arn = aws_lb.clevertap-wordpress.arn
  port              = 80
}

# data "aws_subnet_ids" "subnet_ids" {
#   vpc_id = var.vpc_id
# }

resource "aws_ecs_task_definition" "wordpress" {
  family                   = "wordpress"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  memory                   = "4096"
  cpu                      = "2048"
  execution_role_arn       = "arn:aws:iam::765771042989:role/ecsTaskExecutionRole"
  container_definitions    = jsonencode([
    {
      name = "wordpress"
      image = "${var.ecr_repository_url}:${var.tag}"
      memory = 4096
      cpu = 2048
      essential = true
      portMappings = [
        {
          "containerPort" = 80
          "hostPort" = 80
        }
      ]
    }
  ])
  tags = {
    env = "Development"
    purpose = "Clevertap Wordpress Container"
  }
}

resource "aws_ecs_service" "wordpress-service" {
  name            = "wordpress"
  cluster         = aws_ecs_cluster.wordpress_cluster.id
  task_definition = aws_ecs_task_definition.wordpress.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent = 200

  tags = {
    env = "Development"
    purpose = "From Terraform Service"
  }

  network_configuration {
    subnets          = [aws_subnet.clevertap-subnet-1]
    security_groups  = [ aws_security_group.default.id ]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.wordpresstg.arn
    container_name   = "wordpress"
    container_port   = 80
  }
}
