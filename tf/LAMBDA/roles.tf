####################################################

data "aws_caller_identity" "current" {}


data "aws_iam_policy_document" "lambda_logging" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup"
    ]

    resources = ["arn:aws:logs:${var.region-name}:${data.aws_caller_identity.current.account_id}:*"]
  }

  statement {
    effect = "Allow"

    actions = [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
    ]
    
    resources = ["arn:aws:logs:${var.region-name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.lambda-name}:*"]
  }
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"
  policy      = data.aws_iam_policy_document.lambda_logging.json
}


resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

##########################################

data "aws_iam_policy_document" "allow-get-auto-scalingGroup" {
  statement {
    effect = "Allow"
    actions = [
      "autoscaling:DescribeAutoScalingGroups"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "allow-get-autoscalingGroup" {
  name        = var.autoscaling-policy-name
  path        = "/"
  description = "IAM policy for to get Autoscaling groups"
  policy      = data.aws_iam_policy_document.allow-get-auto-scalingGroup.json
}

resource "aws_iam_role_policy_attachment" "allow-get-autoscalingGroup" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.allow-get-autoscalingGroup.arn
}

#####################################################

data "aws_iam_policy_document" "allow-get-and-put-metric-to-yolov5sqs-name-space" {
  statement {
    effect = "Allow"
    actions = [
      "cloudwatch:GetMetricData",
      "cloudwatch:PutMetricData"
    ]

    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "cloudwatch:namespace"
      values = [
        "yolov5/sqs"
      ]
    }
  }
}


resource "aws_iam_policy" "allow-get-and-put-metric-to-yolov5sqs-name-space" {
  name        = var.sqs-cloudwatch-namespace-policy-name
  path        = "/"
  description = "allow-get-and-put-metric-to-yolov5sqs-name-space"
  policy      = data.aws_iam_policy_document.allow-get-and-put-metric-to-yolov5sqs-name-space.json
}

resource "aws_iam_role_policy_attachment" "allow-get-and-put-metric-to-yolov5sqs-name-space" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.allow-get-and-put-metric-to-yolov5sqs-name-space.arn
}


######################################

data "aws_iam_policy_document" "get-queue-attributes-for-sqs" {
  statement {
    effect = "Allow"
    actions = [
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl"
    ]

    resources = ["arn:aws:sqs:${var.region-name}:${data.aws_caller_identity.current.account_id}:${var.SQS-queue-name}"]
  }
}

resource "aws_iam_policy" "get-queue-attributes-for-sqs" {
  name        = var.sqs-policy-name-get-attributes
  path        = "/"
  description = "allow get attributes from sqs for lambda"
  policy      = data.aws_iam_policy_document.get-queue-attributes-for-sqs.json
}

resource "aws_iam_role_policy_attachment" "get-queue-attributes-for-sqs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.get-queue-attributes-for-sqs.arn
}

