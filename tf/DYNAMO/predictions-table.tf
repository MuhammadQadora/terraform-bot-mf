resource "aws_dynamodb_table" "predictions-table" {
  name           = var.predictions-table-name
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
    Name        = var.predictions-table-name
  }
}