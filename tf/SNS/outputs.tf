output "sns-topic-arn" {
  value = aws_sns_topic.user_updates.arn
}

output "sns-topic-id" {
  value = aws_sns_topic.user_updates.id
}

output "sns-topic-name" {
  value = aws_sns_topic.user_updates.name
}