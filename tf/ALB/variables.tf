variable "alb-name" {
  type = string
  default = "telegrambot-alb"
}

variable "alb-sg-name" {
  type = string
  default = "ALB-sg"
}

variable "vpc_id" {
  type = string
}

variable "internet-cidr" {
  type = string
  default = "0.0.0.0/0"
}

variable "vpc-cidr-block" {
  type = string
}

variable "public-subnet-ids" {
  type = list(string)
}

variable "targetgroup-name" {
  type = string
  default = "telegrambot-target-group"
}

variable "targetgroup-port-number" {
  type = number
  default = 5000
}

variable "certificate_arn" {
  type = string
  default = "arn:aws:acm:ap-northeast-1:933060838752:certificate/c9d30fb0-5a6a-447c-a859-6107cfa564f6"
}