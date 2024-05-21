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

resource "aws_iam_role" "iam_for_yolov5" {
  name               = var.yolov5-role-name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}


data "aws_iam_policy_document" "yolov5-role" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:DescribeTimeToLive",
      "dynamodb:PutItem"
    ]

    resources = ["arn:aws:dynamodb:${var.region-name}:${data.aws_caller_identity.current.account_id}:table/${var.predictions-table-name}"]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
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
      "arn:aws:secretsmanager:us-east-1:933060838752:secret:yolov5-secret-mf-yUf9yi"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "sns:Publish"
    ]
    resources = [
      "arn:aws:sns:${var.region-name}:${data.aws_caller_identity.current.account_id}:${var.sns-name}"

    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "sqs:ReceiveMessage",
      "sqs:GetQueueUrl",
      "sqs:GetQueueAttributes",
      "sqs:DeleteMessage"
    ]
    resources = [
      "arn:aws:sqs:${var.region-name}:${data.aws_caller_identity.current.account_id}:${var.sqs-name}"

    ]
  }
}


resource "aws_iam_instance_profile" "yolov5-profile" {
  name = "yolov5-profile"
  role = aws_iam_role.iam_for_yolov5.name
  depends_on = [ aws_iam_role.iam_for_yolov5 ]
}


resource "aws_iam_policy" "yolov5-policy" {
  name        = "yolov5-policy"
  path        = "/"
  description = "Policy for the yolov5 worker nodes"
  policy      = data.aws_iam_policy_document.yolov5-role.json
}

resource "aws_iam_role_policy_attachment" "yolo5-attachement" {
  role       = aws_iam_role.iam_for_yolov5.name
  policy_arn = aws_iam_policy.yolov5-policy.arn
}
