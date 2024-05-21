output "sqs-name" {
  value = var.sqs-name
}

output "sqs-id" {
  value = aws_sqs_queue.terraform_queue.id
}

output "sqs-arn" {
  value = aws_sqs_queue.terraform_queue.arn
}
