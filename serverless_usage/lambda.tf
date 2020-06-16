# Lambda Function

data "archive_file" "lambda_zip" {
    type                = "zip"
    source_file         = "lambda_code/index.js"
    output_path         = "lambda_function.zip"
}

# refer : https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id          = "AllowExecutionFromAPIGateway"
  action                = "lambda:InvokeFunction"
  function_name         = aws_lambda_function.test_lambda.function_name
  principal             = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.aws_region}:${var.account_id}:${aws_api_gateway_rest_api.demo.id}/*/${aws_api_gateway_method.DemoMethod.http_method}${aws_api_gateway_resource.DemoResource.path}"
}

resource "aws_lambda_function" "test_lambda" {
  filename              = "lambda_function.zip"
  function_name         = "lambda_function_name"
  role                  = aws_iam_role.tf-lambda.arn
  handler               = "index.handler"
  source_code_hash      = data.archive_file.lambda_zip.output_base64sha256
  runtime               = "nodejs10.x"

  environment {
    variables = {
      foo = "bar"
    }
  }

  tags = {
    Name  = "lambda-${var.tag_name}"
  }
}
