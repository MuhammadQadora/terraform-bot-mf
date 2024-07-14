resource "aws_dynamodb_table" "flags-table-dev" {
  name           = var.flags-table-dev-name
  billing_mode   = "PROVISIONED"
  read_capacity  = 4
  write_capacity = 20
  hash_key       = "_id"

  attribute {
    name = "_id"
    type = "N"
  }


  tags = {
    Name        = var.flags-table-dev-name
  }
}


########################################################3

resource "aws_dynamodb_table" "flags-table-prod" {
  name           = var.flags-table-prod-name
  billing_mode   = "PROVISIONED"
  read_capacity  = 4
  write_capacity = 20
  hash_key       = "_id"

  attribute {
    name = "_id"
    type = "N"
  }


  tags = {
    Name        = var.flags-table-prod-name
  }
}