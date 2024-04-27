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

module "YOLOV5" {
  source = "./YOLOV5"
}

output "ami-id" {
  value = module.YOLOV5.ami-id
}