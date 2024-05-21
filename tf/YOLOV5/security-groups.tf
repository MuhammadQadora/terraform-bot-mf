resource "aws_security_group" "yolov5-sg" {
  name        = var.yolov5-sg
  description = "Allow ssh only"
  vpc_id      = var.vpc-id
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.yolov5-sg.id
  cidr_ipv4         = var.public-cidr
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.yolov5-sg.id
  cidr_ipv4         = var.public-cidr
  ip_protocol       = "-1" # semantically equivalent to all ports
}