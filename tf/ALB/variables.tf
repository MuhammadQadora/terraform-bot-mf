variable "alb-name" {
  type = string
  default = "telegrambot-alb"
}

variable "alb-sg-name" {
  type = string
  default = "telegrambot-sg"
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

