resource "aws_lb" "ConsoleApi" {
  name               = var.aws_app_lb_name
  internal           = true
  load_balancer_type = "network"

  subnet_mapping {
    subnet_id = aws_subnet.public.id
  }
}

resource "aws_lb_listener" "ConsoleApi" {
  # oak9: aws_lb_listener.default_action.authenticate_cognito.user_pool_arn is not configured
  load_balancer_arn = aws_lb.ConsoleApi.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ConsoleApi.arn
  }
}

resource "aws_lb_target_group" "ConsoleApi" {
  # oak9: aws_lb_target_group_attachment.availability_zone does not specify availability zones
  name        = "ConsoleApi"
  port        = 80
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = aws_vpc.oak9-vpc.id
  depends_on = [
    aws_lb.ConsoleApi
  ]

  health_check {
    protocol = "TCP"
  }
}