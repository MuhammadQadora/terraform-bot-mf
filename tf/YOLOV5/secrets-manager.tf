resource "aws_secretsmanager_secret" "example" {
  name = var.yolov5-sm
}

resource "aws_secretsmanager_secret_version" "example" {
  secret_id     = aws_secretsmanager_secret.example.id
  secret_string = jsonencode(var.yolov5-secret-values)
}