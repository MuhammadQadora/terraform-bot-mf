resource "aws_lb_target_group" "telegrambot-tg" {
  name     = var.targetgroup-name
  port     = var.targetgroup-port-number
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled = true
    path = "/"
  }
}