terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.0"
    }
  }

  backend "s3" {
    bucket = "tfstatefile-mf"
    key    = "tfstate"
    region = "us-east-1"
  }

  required_version = ">= 1.7.0"
}

provider "aws" {
  region = var.region
}

module "network" {
  source = "./network"
}

module "ALB" {
  source = "./ALB"
  vpc_id = module.network.vpc_id
  vpc-cidr-block = module.network.vpc-cidr-block
  public-subnet-ids = module.network.public-subnets-id
}
# module "YOLOV5" {
#   source = "./YOLOV5"
#   yolov5-sm = "yolov5-secret-${var.region}"
#   yolov5-secret-values = var.yolov5Values
#   depends_on = [ module.network ]
# }

# output "ami-id" {
#   value = module.YOLOV5.ami-id
# }
output "private-subnets" {
  value = module.network.private-subnets-id
}

output "public-subnets" {
  value = module.network.public-subnets-id
}

output "ALB-DNS" {
  value = module.ALB.ALB-DNS
}
output "azs" {
  value = module.network.azs
}