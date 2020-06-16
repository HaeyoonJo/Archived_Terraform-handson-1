# api gateway creation
resource "aws_api_gateway_rest_api" "demo" {
  name                    = "DemoAPI"
  description             = "This is my API for demonstration purposes"

  endpoint_configuration {
    # Type value: Edge optimized
    types = ["EDGE"]
  }

  tags = {
    Name  = "apigw-${var.tag_name}"
  }
}

# aurhorizer creation in order to be connected to the user pool
resource "aws_api_gateway_authorizer" "demo" {
  name                    = "MyDemoAPI_auth"
  rest_api_id             = aws_api_gateway_rest_api.demo.id
  type                    = "COGNITO_USER_POOLS"
  provider_arns = [aws_cognito_user_pool.pool.arn]
}

resource "aws_api_gateway_resource" "DemoResource" {
  rest_api_id             = aws_api_gateway_rest_api.demo.id
  parent_id               = aws_api_gateway_rest_api.demo.root_resource_id
  path_part               = "ride"
}

resource "aws_api_gateway_method" "DemoMethod" {
  rest_api_id             = aws_api_gateway_rest_api.demo.id
  resource_id             = aws_api_gateway_resource.DemoResource.id
  http_method             = "POST"
  authorization           = "COGNITO_USER_POOLS"
  authorizer_id           = aws_api_gateway_authorizer.demo.id
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.demo.id
  resource_id             = aws_api_gateway_resource.DemoResource.id
  http_method             = aws_api_gateway_method.DemoMethod.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.test_lambda.invoke_arn
}

# refer the following:
#   https://github.com/squidfunk/terraform-aws-api-gateway-enable-cors
# API Gateway Enable CORS
module "example_cors" {
  source                  = "squidfunk/api-gateway-enable-cors/aws"
  version                 = "0.3.1"
  api_id                  = aws_api_gateway_rest_api.demo.id
  api_resource_id         = aws_api_gateway_resource.DemoResource.id
}
