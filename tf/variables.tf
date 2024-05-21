variable "region" {
  type = string
}

variable "autoscaling-group-name" {
  type = string
}

variable "sqs-queue-name" {
  type = string
}

variable "ec2_public_key" {
  type      = string
  sensitive = true
}

variable "domain-name" {
  type    = string
  default = "https://mf.atech-bot.click"
}

variable "sns-name" {
  type = string
}