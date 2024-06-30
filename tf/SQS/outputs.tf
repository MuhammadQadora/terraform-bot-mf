output "sqs-name-dev" {
  value = var.sqs-name-dev
}

output "sqs-name-prod" {
  value = var.sqs-name-prod
}


output "sqs-id-dev" {
  value = aws_sqs_queue.sqs_dev.id
}

output "sqs-id-prod" {
  value = aws_sqs_queue.sqs_prod.id
}

output "sqs-arn-dev" {
  value = aws_sqs_queue.sqs_dev.arn
}


output "sqs-arn-prod" {
  value = aws_sqs_queue.sqs_prod.id
}
