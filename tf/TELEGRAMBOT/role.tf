
data "aws_caller_identity" "current" {}


data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_instance_profile" "telegrambot-profile" {
  name = "telegram-profile"
  role = aws_iam_role.telegrambot-role.name
  depends_on = [ aws_iam_role.telegrambot-role ]
}

resource "aws_iam_role" "telegrambot-role" {
  name               = "telegrambot-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}


data "aws_iam_policy_document" "policy" {
  statement {
    effect    = "Allow"
    actions   = [
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:Query",
        "dynamodb:Scan"
    ]
    resources = [
        "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/${var.openai-table-name}",
        "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/${var.telegram-dynamo-table-name}"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
        "s3:PutObject"
    ]
    resources = [
        "arn:aws:s3:::mqbucket1/*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
        "secretsmanager:GetSecretValue"
    ]
    resources = [
    "arn:aws:secretsmanager:us-east-1:${data.aws_caller_identity.current.account_id}:secret:polybotSecretsMQ-eC5Tdq"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
        "sns:GetSubscriptionAttributes",
        "sns:ConfirmSubscription",
        "sns:Subscribe",
        "sns:Unsubscribe"
    ]
    resources = [
        "arn:aws:sns:${var.region}:${data.aws_caller_identity.current.account_id}:${var.sns-name}"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
        "sqs:GetQueueUrl",
        "sqs:SendMessage"
    ]
    resources = [
         "arn:aws:sqs:${var.region}:${data.aws_caller_identity.current.account_id}:${var.sqs-name}"
    ]
  }
}

resource "aws_iam_policy" "telegrambot-policy" {
  name        = "telegrambot-policy"
  path        = "/"
  description = "Policy for the telegrambot nodes"
  policy      = data.aws_iam_policy_document.policy.json
}

resource "aws_iam_role_policy_attachment" "telegrambot-attachement" {
  role       = aws_iam_role.telegrambot-role.name
  policy_arn = aws_iam_policy.telegrambot-policy.arn
}
