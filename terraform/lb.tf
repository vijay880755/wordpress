resource "aws_lb" "cleartap-wordpress" {
  name               = "cleartap-wordpress"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.default.id]
  subnets            = [aws_subnet.clevertap-subnet-1,aws_subnet.clevertap-subnet-2]

  enable_deletion_protection = true
  tags = {
    Environment = "development"
  }
}
