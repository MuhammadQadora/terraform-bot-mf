variable "external_dns_role_arn" {
  type = string
}

variable "region" {
  type = string
}

variable "aws_ingress_controller_role_arn" {
  type = string
}

variable "cluster_name" {
  type = string
}

# variable "karpenter_role_arn" {
#   type = string
# }

variable "cluster_endpoint" {
  type = string
}

# variable "karpenter_instance_profile" {
#   type = string
# }

variable "vpc_id" {
  type = string
}

variable "cluster_autoscaler_role_arn" {
  type = string
}