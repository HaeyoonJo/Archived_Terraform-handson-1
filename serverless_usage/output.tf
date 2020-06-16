output "s3_website_endpoint" {
  value = aws_s3_bucket.unicorn.website_endpoint
}

output "cognito_id" {
  value = aws_cognito_user_pool.pool.id
}

output "cognito_client_id" {
  value = aws_cognito_user_pool_client.client.id
}

output "dynamodb_arn" {
  value = aws_dynamodb_table.ride-dynamodb-table.arn
}
