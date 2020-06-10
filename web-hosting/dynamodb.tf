# DynamoDB creation

resource "aws_dynamodb_table" "ride-dynamodb-table" {
  name           = "tf-rides"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "TfRideId"

  attribute {
    name = "TfRideId"
    type = "S"
  }

  tags = {
    Name  = "dynamodb-${var.tag_name}"
  }
}
