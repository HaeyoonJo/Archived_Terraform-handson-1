# cognito

resource "aws_cognito_user_pool" "pool" {
  name    = "pool-test"
  auto_verified_attributes = ["email"]
  tags = {
    Name  = "cognito-${var.tag_name}"
  }
}

resource "aws_cognito_user_pool_client" "client" {
  name          = "client-test"
  user_pool_id  = aws_cognito_user_pool.pool.id

  # It seems that values are given by default even if no value is specified
  # generate_secret, explicit_auth_flows are defaulted
  generate_secret = false
  explicit_auth_flows = ["ALLOW_CUSTOM_AUTH", "ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
}
