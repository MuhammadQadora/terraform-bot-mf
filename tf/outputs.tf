output "private_subnets" {
  value = module.network.private-subnets-id
}

output "public_subnets" {
  value = module.network.public-subnets-id
}

output "ALB_DNS" {
  value = module.ALB.ALB-DNS
}
output "azs" {
  value = module.network.azs
}
output "sqs_id" {
  value = module.sqs.sqs-id
}
output "sqs_arn" {
  value = module.sqs.sqs-arn
}

output "sns_id" {
  value = module.sns.sns-topic-id
}

output "sns_arn" {
  value = module.sns.sns-topic-arn
}

output "sqs_name" {
  value = module.sqs.sqs-name
}

output "region" {
  value = var.region
}

output "domain_name" {
  value = var.domain-name
}