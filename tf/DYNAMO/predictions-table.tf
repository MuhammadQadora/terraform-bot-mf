resource "aws_dynamodb_table" "predictions-table-dev" {
  name           = var.predictions-table-name-dev
  billing_mode   = "PROVISIONED"
  read_capacity  = 4
  write_capacity = 20
  hash_key       = "_id"

  attribute {
    name = "_id"
    type = "S"
  }


  ttl {
    attribute_name = "TTL"
    enabled        = true
  }

  tags = {
    Name        = var.predictions-table-name-dev
  }
}


########################################################3

resource "aws_dynamodb_table" "predictions-table-prod" {
  name           = var.predictions-table-name-prod
  billing_mode   = "PROVISIONED"
  read_capacity  = 4
  write_capacity = 20
  hash_key       = "_id"

  attribute {
    name = "_id"
    type = "S"
  }


  ttl {
    attribute_name = "TTL"
    enabled        = true
  }

  tags = {
    Name        = var.predictions-table-name-prod
  }
}