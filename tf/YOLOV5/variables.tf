variable "template-name" {
  type = string
  default = "yolov5-template-terraform"
}

variable "ami-id" {
  type = string
}

variable "yolov5-role-name" {
 type = string
 default = "yolov5-role-for-ec2-terraform" 
}

variable "region-name" {
  type = string
}

variable "predictions-table-name" {
  type = string
}

variable "sns-name" {
  type = string
}

variable "sqs-name" {
  type = string
}


variable "instance-type" {
  type = string
  default = "t3.small"
}

variable "ec2-public_key" {
  type = string
  sensitive = true
}

variable "yolov5-sg" {
  type = string
  default = "yolov5-sg-terraform"
}

variable "vpc-id" {
  type = string
}

variable "vpc-cidr" {
  type = string
}

variable "sns-arn" {
  type = string
}

variable "dynamo-table-name" {
  type = string
}

variable "public-azs" {
  type = list(string)
}

variable "key-name" {
  type = string
}

variable "autoscaling-group-name" {
  type = string
}

variable "public-cidr" {
  type = string
  default = "0.0.0.0/0"
}