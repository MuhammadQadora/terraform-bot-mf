resource "aws_security_group" "telegram-sg" {
  name        = var.telegrambot-sg-name
  description = "allows port 5000 only from ALB"
  vpc_id      = var.vpc-id

  tags = {
    Name = "allow_5000"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.telegram-sg.id
  cidr_ipv4 = var.public-cidr
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow-app" {
  security_group_id = aws_security_group.telegram-sg.id
  referenced_security_group_id = var.alb-sg-id
  from_port         = 5000
  ip_protocol       = "tcp"
  to_port           = 5000
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.telegram-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}