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
output "sqs-id" {
  value = module.sqs.sqs-id
}
output "sqs-arn" {
  value = module.sqs.sqs-arn
}

output "sns-id" {
  value = module.sns.sns-topic-id
}

output "sns-arn" {
  value = module.sns.sns-topic-arn
}

output "sqs-name" {
  value = module.sqs.sqs-name
}