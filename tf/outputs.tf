# output "issuer_url" {
#   value = module.eks.issuer_url
# }

output "vpc_id" {
  value = module.network.vpc_id
}

output "region" {
  value = var.region
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "sqs_url_dev" {
  value = module.sqs.sqs-name-dev
}

output "sqs_url_prod" {
  value = module.sqs.sqs-name-prod
}

output "sns_url_dev" {
  value = module.sns.sns-topic-name-dev
}

output "sns_url_prod" {
  value = module.sns.sns-topic-name-dev
}

output "dynamo_table_dev" {
  value = module.dynamodb.predictions-table-name-dev
}
output "dynamo_table_prod" {
  value = module.dynamodb.predictions-table-name-prod
}

output "gpt_table_dev" {
  value = module.dynamodb.openai-table-name-dev
}
output "gpt_table_prod" {
  value = module.dynamodb.openai-table-name-dev
}

output "sns_arn_dev" {
  value = module.sns.sns-topic-arn-dev
}

output "sns_arn_prod" {
  value = module.sns.sns-topic-arn-prod
}

output "new" {
  value = module.dynamodb.flags-table-name-dev
}