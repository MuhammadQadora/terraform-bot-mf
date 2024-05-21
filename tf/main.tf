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

module "sqs" {
  source   = "./SQS"
  sqs-name = var.sqs-queue-name
}

module "sns" {
  source       = "./SNS"
  sns-top-name = var.sns-name
}

module "key-pair" {
  source         = "./KEYPAIR"
  ec2-public_key = var.ec2_public_key
}

module "lambda" {
  source                  = "./LAMBDA"
  region-name             = var.region
  auto-scaling-group-name = var.autoscaling-group-name
  SQS-queue-name          = var.sqs-queue-name
  depends_on              = [module.sqs]
}

module "route53" {
  source       = "./ROUTE53"
  ALB-dns-name = module.ALB.ALB-DNS
  ALB-zone-id  = module.ALB.ALB-zone-id
  depends_on   = [module.ALB]
}
module "ALB" {
  source            = "./ALB"
  vpc_id            = module.network.vpc_id
  vpc-cidr-block    = module.network.vpc-cidr-block
  public-subnet-ids = module.network.public-subnets-id
}

module "dynamodb" {
  source = "./DYNAMO"
}


module "telegrambot" {
  source                     = "./TELEGRAMBOT"
  ami-id                     = data.aws_ami.ubuntu.id
  bot-subnet-id              = module.network.public-subnets-id[0]
  key-name                   = module.key-pair.key-name
  region                     = var.region
  sns-arn                    = module.sns.sns-topic-arn
  domain-name                = var.domain-name
  alb-target_group_arn       = module.ALB.target_group_arn
  vpc-id                     = module.network.vpc_id
  vpc-cidr                   = module.network.vpc-cidr-block
  sqs-name                   = module.sqs.sqs-name
  openai-table-name          = module.dynamodb.openai-table-name
  sns-name                   = module.sns.sns-topic-name
  alb-sg-id                  = module.ALB.ALB-sg-id
  telegram-dynamo-table-name = module.dynamodb.predictions-table-name
  depends_on                 = [module.network, module.sqs, module.sns, module.dynamodb, module.key-pair, module.ALB]
}



module "YOLOV5" {
  source                 = "./YOLOV5"
  region-name            = var.region
  autoscaling-group-name = var.autoscaling-group-name
  predictions-table-name = module.dynamodb.predictions-table-name
  sns-name               = module.sns.sns-topic-name
  sqs-name               = module.sqs.sqs-name
  ec2-public_key         = var.ec2_public_key
  key-name               = module.key-pair.key-name
  public-azs             = module.network.public-subnets-id
  vpc-id                 = module.network.vpc_id
  vpc-cidr               = module.network.vpc-cidr-block
  sns-arn                = module.sns.sns-topic-arn
  dynamo-table-name      = module.dynamodb.predictions-table-name
  ami-id                 = data.aws_ami.ubuntu.id
  depends_on             = [module.network, module.sqs, module.sns, module.dynamodb, module.key-pair]
}

output "ami-id" {
  value = data.aws_ami.ubuntu.id
}