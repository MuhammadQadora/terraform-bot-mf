output "ALB-DNS" {
  value = aws_lb.telegrambot-alb.dns_name
}

output "ALB-zone-id" {
  value = aws_lb.telegrambot-alb.zone_id
}

output "ALB-sg-id" {
  value = aws_security_group.allow_tls.id
}

output "target_group_arn" {
  value = aws_lb_target_group.telegrambot-tg.arn
}