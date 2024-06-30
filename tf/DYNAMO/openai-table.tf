resource "aws_dynamodb_table" "openai-table-dev" {
  name           = var.openai-table-name-dev
  billing_mode   = "PROVISIONED"
  read_capacity  = 10
  write_capacity = 10
  hash_key       = "_id"

  attribute {
    name = "_id"
    type = "N"
  }

  tags = {
    Name        = var.openai-table-name-dev
  }
}

######################################################3
######

resource "aws_dynamodb_table" "openai-table-prod" {
  name           = var.openai-table-name-prod
  billing_mode   = "PROVISIONED"
  read_capacity  = 10
  write_capacity = 10
  hash_key       = "_id"

  attribute {
    name = "_id"
    type = "N"
  }

  tags = {
    Name        = var.openai-table-name-prod
  }
}
