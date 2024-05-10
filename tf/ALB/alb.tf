resource "aws_lb" "telegrambot-alb" {
  name               = var.alb-name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_tls.id]
  subnets            = [for subnet in var.public-subnet-ids : subnet]

  enable_deletion_protection = false
  depends_on = [ aws_lb_target_group.telegrambot-tg ]
}


resource "aws_lb_listener" "telegrambot-alb-listener" {
  load_balancer_arn = aws_lb.telegrambot-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.telegrambot-tg.arn
  }
  depends_on = [ aws_lb.telegrambot-alb,aws_acm_certificate.cert ]
}