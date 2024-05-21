resource "aws_cloudwatch_event_target" "example" {
  arn  = aws_lambda_function.test_lambda.arn
  rule = aws_cloudwatch_event_rule.rule-1m.id
}

resource "aws_cloudwatch_event_rule" "rule-1m" {
  name = "one-minute-lambda-trigger"
  schedule_expression = "rate(1 minute)"
}