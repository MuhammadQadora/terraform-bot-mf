terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.0"
    }
    # kubectl = {
    #   source  = "gavinbunney/kubectl"
    #   version = ">= 1.7.0"
    # }
  }

  backend "s3" {
    bucket      = "tfstatefile-mf"
    key         = "tfstate"
    region      = "us-east-1"
    max_retries = 1
  }

  required_version = ">= 1.7.0"
}



provider "aws" {
  region = var.region
}


data "aws_eks_cluster_auth" "cluster_auth" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}

provider "kubernetes" {
  host                   = module.eks.endpoint
  cluster_ca_certificate = base64decode(module.eks.kubeconfig-certificate-authority-data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    command     = "aws"
  }
}


provider "helm" {
  kubernetes {
    host                   = module.eks.endpoint
    cluster_ca_certificate = base64decode(module.eks.kubeconfig-certificate-authority-data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
      command     = "aws"
    }
  }
}

# provider "kubectl" {
#   host                   = module.eks.endpoint
#   cluster_ca_certificate = base64decode(module.eks.kubeconfig-certificate-authority-data)
#   exec {
#       api_version = "client.authentication.k8s.io/v1beta1"
#       args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
#       command     = "aws"
#     }
#   load_config_file       = false
# }

module "network" {
  source = "./network"
}

module "eks" {
  source                 = "./EKS"
  private_subnet_ids     = module.network.private-subnets-id
  public_subnet_ids      = module.network.public-subnets-id
  region                 = var.region
  sns_name_dev = module.sns.sns-topic-name-dev
  sns_name_prod = module.sns.sns-topic-name-prod
  sqs_name_dev = module.sqs.sqs-name-dev
  sqs_name_prod = module.sqs.sqs-name-
  flags_table_dev = module.dynamodb.flags-table-name-dev
  flags_table_prod = module.dynamodb.flags-table-name-prod
  predictions_table_name_dev = module.dynamodb.predictions-table-name-dev
  predictions_table_name_prod = module.dynamodb.predictions-table-name-prod
  gpt_table_name_dev         = module.dynamodb.openai-table-name-dev
  gpt_table_name_prod = module.dynamodb.openai-table-name-prod
  depends_on             = [module.network]
}


module "sqs" {
  source   = "./SQS"
  sqs-name-dev = var.sqs_name_dev
  sqs-name-prod = var.sqs_name_prod
}

module "sns" {
  source       = "./SNS"
  sns-dev-top-name = var.sns_name_dev
  sns-prod-top-name = var.sns_name_prod
}


module "dynamodb" {
  source = "./DYNAMO"
}




module "helm" {
  source                          = "./HELM"
  cluster_endpoint                = module.eks.endpoint
  region                          = var.region
  vpc_id                          = module.network.vpc_id
  cluster_autoscaler_role_arn     = module.eks.cluster-autoscaler-role-arn
  aws_ingress_controller_role_arn = module.eks.aws_ingress_controller_role_arn
  external_dns_role_arn           = module.eks.external_dns_role_arn
  cluster_name                    = module.eks.cluster_name
  karpenter-role = module.eks.aws_karpenter_role_arn
  depends_on                      = [module.eks]
}
