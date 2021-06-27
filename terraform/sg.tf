variable "name"{
 default = "wordpress-cluster"
}
resource "aws_security_group" "default" {
  description = "security group for ${var.name} service"
  name        = var.name
  vpc_id = aws_vpc.clevertap-vpc.id
}

resource "aws_security_group_rule" "service_in_lb" {
  description = "Allow inbound TCP connections from the LB to ECS service ${var.name}"

  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  cidr_blocks              = ["0.0.0.0/0"]

  security_group_id = aws_security_group.default.id
}
resource "aws_security_group_rule" "service_out" {
  description = "Allow outbound connections for all protocols and all ports for ECS service ${var.name}"

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = -1
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.default.id
}

