resource "aws_lb_target_group_attachment" "one" {
  target_group_arn = var.alb-target_group_arn
  target_id        = aws_instance.telegrambot.id
  port             = 5000
}