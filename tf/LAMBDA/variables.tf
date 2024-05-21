variable "lambda-role-name" {
  type = string
  default = "lambda-yolov5-sqs-role"
}

variable "lambda-name" {
  type = string
  default = "lambda-yolov5-sqs"
}

variable "region-name" {
  type = string
}

variable "cloud-watch-file-name" {
  type = string
  default = "cloudwatch-code.py"
}

variable "autoscaling-policy-name" {
  type = string
  default = "allow-get-auto-scalingGroup-terraform"
}

variable "auto-scaling-group-name" {
  type = string
}

variable "SQS-queue-name" {
  type = string
}

variable "sqs-cloudwatch-namespace-policy-name" {
  type = string
  default = "allow-get-and-put-metric-to-yolov5sqs-name-space-terraform"
}


variable "sqs-policy-name-get-attributes" {
  type = string
  default = "get-queue-attributes-for-sqs-terraform"
}