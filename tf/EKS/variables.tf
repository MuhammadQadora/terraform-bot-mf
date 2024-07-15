variable "role_name" {
  type = string
  default = "eks-cluster-role-mf"
}

variable "cluster_name" {
  type = string
  default = "mf-cluster"
}

variable "authentication_mode" {
    type = string
    default = "API_AND_CONFIG_MAP"
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "user_name" {
  type = string
  default = "memomq"
}

variable "user_name_firas" {
  type = string
  default = "firas.narani"
}

variable "region" {
  type = string
}

variable "gpt_table_name_dev" {
  type = string
}

variable "gpt_table_name_prod" {
  type = string
}


variable "predictions_table_name_dev" {
  type = string
}

variable "predictions_table_name_prod" {
  type = string
}

variable "sns_name_dev" {
  type = string
}
variable "sns_name_prod" {
  type = string
}


variable "sqs_name_prod" {
  type = string
}


variable "sqs_name_dev" {
  type = string
}