variable "ami-id" {
  type = string
}

variable "instance_type" {
  type = string
  default = "t3.micro"
}

variable "bot-subnet-id" {
  type = string
}

variable "key-name" {
  type = string
}

variable "region" {
  type = string
}

variable "openai-table-name" {
  type = string
}

variable "telegram-dynamo-table-name" {
  type = string
}

variable "sns-name" {
  type = string
}

variable "sqs-name" {
  type = string
}

variable "domain-name" {
  type = string
}

variable "sns-arn" {
  type = string
}

variable "telegrambot-sg-name" {
  type = string
  default = "telegrambot-sg"
}

variable "vpc-id" {
  type = string
}

variable "vpc-cidr" {
  type = string
}

variable "alb-sg-id" {
  type = string 
}

variable "alb-target_group_arn" {
  type = string
}

variable "public-cidr" {
  type = string
  default = "0.0.0.0/0"
}