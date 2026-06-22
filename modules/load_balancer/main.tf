
#  Creating target group and registering vms to it.
resource "aws_lb_target_group" "webserver_tg" {
  name        = "webserver-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.aws_vpc_id
  target_type = "instance"

  health_check {
    enabled             = true
    path                = "/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200"
  }

  tags = {
    Environment = "production_webserver_lb"
  }
}

resource "aws_lb_target_group_attachment" "webserver_tg_attachment" {
  target_group_arn = aws_lb_target_group.webserver_tg.arn
  target_id        = var.private_server_one_id
  port             = 80
}

resource "aws_lb_target_group_attachment" "webserver_tg_attachment_two" {
  target_group_arn = aws_lb_target_group.webserver_tg.arn
  target_id        = var.private_server_two_id
  port             = 80
}

#  Creating loadbalancer
resource "aws_lb" "webserver_lb" {
  name               = "webserver-alb"
  load_balancer_type = "application"
  security_groups    = [var.security_groups]
  subnets            = var.public_subnet_ids # Requires 2+ subnets in different AZs
}