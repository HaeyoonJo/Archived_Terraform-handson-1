data "aws_lambda_invocation" "example" {
  function_name = aws_lambda_function.test_lambda.function_name
  input = file("lambda_code/lambda_event.json")
}

output "result" {
  description = "String result of Lambda execution"
  value       = data.aws_lambda_invocation.example.result
}

output "result_entry_tf012" {
  value = jsondecode(data.aws_lambda_invocation.example.result)
}
