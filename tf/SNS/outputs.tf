output "sns-topic-arn-dev" {
  value = aws_sns_topic.user_updates_dev.arn
}
output "sns-topic-arn-prod" {
  value = aws_sns_topic.user_updates_prod.arn
}


output "sns-topic-id-prod" {
  value = aws_sns_topic.user_updates_prod.id
}

output "sns-topic-id-dev" {
  value = aws_sns_topic.user_updates_dev.id
}

output "sns-topic-name-dev" {
  value = aws_sns_topic.user_updates_dev.name
}
output "sns-topic-name-prod" {
  value = aws_sns_topic.user_updates_prod.name
}