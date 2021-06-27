resource "aws_lb" "clevertap-wordpress" {
  name               = "cleartap-wordpress"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.default.id]
  subnets            = [aws_subnet.clevertap-subnet-1.id,aws_subnet.clevertap-subnet-2.id]

  enable_deletion_protection = true
  tags = {
    Environment = "development"
  }
}

resource "aws_lb_target_group" "wordpresstg" {
  name                               = "wordpresstg"
  port                               = var.health_check.port
  protocol                           = var.health_check.protocol
  vpc_id                             = aws_vpc.clevertap-vpc.id
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
resource "aws_lb_listener" "clevertap-wordpress" {
  load_balancer_arn = aws_lb.clevertap-wordpress.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpresstg.arn
  }
}
resource "aws_alb_listener_rule" "alb_rules" {
  listener_arn = aws_lb_listener.clevertap-wordpress.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpresstg.arn
 }
 condition {
    path_pattern {
      values = ["/wp-admin/setup-config.php"]
    }
  } 
 }
