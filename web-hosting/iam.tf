# create a role that accessable
# to Lambda function and the dynamodb table specified
# in the iam_role_policy_dynamodb.json file
resource "aws_iam_role" "tf-lambda" {
  name                = "tf-LambdaExecRole"
  assume_role_policy  = file("policy_json/iam_assume_role_policy.json")

  tags = {
    Name  = "iam-role-${var.tag_name}"
  }
}

# attach inline policy in order to attach created dynamodb my own
resource "aws_iam_role_policy" "policy" {
  name    = "DynamoDBWriteAccess"
  role    = aws_iam_role.tf-lambda.name
  policy  = file("policy_json/aws_iam_role_policy_dynamodb.json")
}

# attach AWSLambdaBasicExecutionRole policy in order to excute Lambda Function
resource "aws_iam_role_policy_attachment" "test-attach" {
  role        = aws_iam_role.tf-lambda.name
  policy_arn  = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


# This resource isnt work in order to attach the dynamodbWrite policy,
# bc attaching is works on aws_iam_role_policy.policy resource.
# No need to write the attachment as below.
# resource "aws_iam_role_policy_attachment" "test-attach1" {
#   role       = aws_iam_role.tf-lambda.name
#   policy_arn = aws_iam_role_policy.policy.name
# }
