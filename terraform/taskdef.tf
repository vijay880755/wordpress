data "aws_lb" "selected" {
  name  = lookup(var.load_balancer, "name")
}

data "aws_lb_listener" "selected" {
  load_balancer_arn = data.aws_lb.selected.arn
  port              = 80
}

data "aws_subnet_ids" "subnet_ids" {
  vpc_id = var.vpc_id
}

resource "aws_ecs_task_definition" "wordpress" {
  family                   = "wordpress"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  memory                   = "1024"
  cpu                      = "512"
  execution_role_arn       = "arn:aws:iam::765771042989:role/ecsTaskExecutionRole"
  container_definitions    = jsonencode([
    {
      name = "wordpress"
      image = "${var.ecr_repository_url}:${var.tag}"
      memory = 1024
      cpu = 512
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
    purpose = "From Terraform Task Def"
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
    subnets          = data.aws_subnet_ids.subnet_ids.ids
    security_groups  = [ aws_security_group.default.id ]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.wordpresstg.arn
    container_name   = "wordpress"
    container_port   = 80
  }
}
resource "aws_lb_target_group" "wordpresstg" {
  name                               = "wordpresstg"
  port                               = var.health_check.port
  protocol                           = var.health_check.protocol
  vpc_id                             = var.vpc_id
  target_type                        = "ip"
  proxy_protocol_v2                  = "false"
  health_check {
      enabled             = "true"
      interval            = var.health_check.interval
      port                = var.health_check.port
      path                = var.health_check.path
      healthy_threshold   = var.health_check.healthy_threshold
      unhealthy_threshold = var.health_check.unhealthy_threshold
      timeout             = var.health_check.timeout
      protocol            = var.health_check.protocol
      matcher             = var.health_check.matcher
  }
}

resource "aws_alb_listener_rule" "alb_rules" {
  listener_arn = data.aws_lb_listener.selected.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpresstg.arn
 }
 condition {
    path_pattern {
      values = ["/"]
    }
  } 
 }

