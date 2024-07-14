variable "predictions-table-name-dev" {
  type = string
  default = "predictions-table-terraform-dev"
}

variable "predictions-table-name-prod" {
  type = string
  default = "predictions-table-terraform-prod"
}

variable "openai-table-name-dev" {
  type = string
  default = "openai-table-terraform-dev"
}

variable "openai-table-name-prod" {
  type = string
  default = "openai-table-terraform-prod"
}

variable "flags-table-dev-name" {
  type = string
  default = "flags-table-terraform-dev"
}

variable "flags-table-prod-name" {
  type = string
  default = "flags-table-terraform-prod"
}