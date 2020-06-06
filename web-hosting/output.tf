output "s3_website_endpoint" {
  value = aws_s3_bucket.unicorn.website_endpoint
}

output "cognito" {
  value = aws_cognito_user_pool.pool.id
}

output "cognito_client" {
  value = aws_cognito_user_pool_client.client.id
}
