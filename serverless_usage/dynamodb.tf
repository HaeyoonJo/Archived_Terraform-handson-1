variable "dynamo_hash_key" {}

# DynamoDB creation
resource "aws_dynamodb_table" "ride-dynamodb-table" {
  name            = var.dynamodb_table_name
  billing_mode    = "PROVISIONED"
  read_capacity   = 5
  write_capacity  = 5
  hash_key        = var.dynamo_hash_key

  attribute {
    name          = var.dynamo_hash_key
    type          = "S" # String type
  }

  tags = {
    Name  = "dynamodb-${var.tag_name}"
  }
}
