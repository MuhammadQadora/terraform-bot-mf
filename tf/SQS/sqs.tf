resource "aws_sqs_queue" "sqs_dev" {
  name                      = var.sqs-name-dev
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 20
  tags = {
    "Name" = "telegram-sqs"
  }
}


data "aws_iam_policy_document" "basic-allow" {
  statement {
    sid    = "basic allow"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::933060838752:root"]
    }

    actions   = ["sqs:*"]
    resources = [aws_sqs_queue.sqs_dev.arn]
  }
}

resource "aws_sqs_queue_policy" "dev" {
  queue_url = aws_sqs_queue.sqs_dev.id
  policy    = data.aws_iam_policy_document.basic-allow.json
  depends_on = [ aws_sqs_queue.sqs_dev]
}

##############################################################
###################################

resource "aws_sqs_queue" "sqs_prod" {
  name                      = var.sqs-name-prod
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 20
  tags = {
    "Name" = "telegram-sqs"
  }
}

resource "aws_sqs_queue_policy" "prod" {
  queue_url = aws_sqs_queue.sqs_prod.id
  policy    = data.aws_iam_policy_document.basic-allow.json
  depends_on = [ aws_sqs_queue.sqs_prod]
}