resource "aws_iam_role" "role" {
  name = "tf-LambdaExecRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = {
    Name = "tf-iam-role-${var.tag_name}"
  }
}

resource "aws_iam_role_policy" "policy" {
  name = "DynamoDBWriteAccess"
  role = aws_iam_role.role.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "dynamodb:PutItem",
            "Resource": "arn:aws:dynamodb:eu-central-1:896457211177:table/tf-rides"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

#  This resource isnt work in order to attach the dynamodbWrite policy. bc attaching is works on aws_iam_role_policy.policy resource.
#  No need to write the attachment as below:
# resource "aws_iam_role_policy_attachment" "test-attach1" {
#   role       = aws_iam_role.role.name
#   policy_arn = aws_iam_role_policy.policy.name
# }
