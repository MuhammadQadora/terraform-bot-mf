data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = var.lambda-role-name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/${var.cloud-watch-file-name}"
  output_path = "${path.module}/app.zip"
}

resource "aws_lambda_function" "test_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "${path.module}/app.zip"
  function_name = var.lambda-name
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "cloudwatch-code.lambda_handler"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.12"

  environment {
    variables = {
      region = var.region-name
      AUTOSCALING_GROUP_NAME = var.auto-scaling-group-name
      QUEUE_NAME = var.SQS-queue-name
    }
  }
  depends_on = [ aws_iam_role_policy_attachment.lambda_logs, aws_iam_role_policy_attachment.allow-get-and-put-metric-to-yolov5sqs-name-space, aws_iam_role_policy_attachment.allow-get-autoscalingGroup
  , aws_iam_role_policy_attachment.get-queue-attributes-for-sqs ]
}


resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.rule-1m.arn
  #qualifier     = aws_lambda_alias.test_lambda_alias.name
  lifecycle {
    replace_triggered_by = [
      aws_lambda_function.test_lambda
    ]
  }
  depends_on = [ aws_lambda_function.test_lambda]
}


# resource "aws_lambda_alias" "test_lambda_alias" {
#   name             = "lambda-yolov5-sqs"
#   description      = "a sample description"
#   function_name    = aws_lambda_function.test_lambda.arn
#   function_version = "$LATEST"
#   depends_on = [ aws_lambda_function.test_lambda ]
# }