# DynamoDB creation

resource "aws_dynamodb_table" "ride-dynamodb-table" {
  name           = "tfrides"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "RideId"

  attribute {
    name = "RideId"
    type = "S"
  }

  tags = {
    Name  = "dynamodb-${var.tag_name}"
  }
}
