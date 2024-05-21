resource "aws_security_group" "allow_tls" {
  name        = var.alb-sg-name
  description = "Allow TLS and http inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = var.internet-cidr
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

# resource "aws_vpc_security_group_ingress_rule" "allow_http" {
#   security_group_id = aws_security_group.allow_tls.id
#   cidr_ipv4         = var.vpc-cidr-block
#   from_port         = 80
#   ip_protocol       = "tcp"
#   to_port           = 80
# }

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = var.internet-cidr
  ip_protocol       = "-1" # semantically equivalent to all ports
}
