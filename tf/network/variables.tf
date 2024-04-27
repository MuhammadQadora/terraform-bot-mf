variable "vpc-cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "public-cidr" {
  type = string
  default = "0.0.0.0/0"
}

variable "public-rt-name" {
  type = string
  default = "public-rt"
}
variable "private-rt-name" {
  type = string
  default = "private-rt"
}