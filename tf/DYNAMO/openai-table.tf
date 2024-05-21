resource "aws_dynamodb_table" "openai-table" {
  name           = var.openai-table-name
  billing_mode   = "PROVISIONED"
  read_capacity  = 10
  write_capacity = 10
  hash_key       = "_id"

  attribute {
    name = "_id"
    type = "N"
  }

  tags = {
    Name        = var.predictions-table-name
  }
}