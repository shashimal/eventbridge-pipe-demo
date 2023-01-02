resource "aws_iam_role" "eventbridge_pipe_sqs_role" {
  name               = "eventbridge-pipe-sqs-role"
  assume_role_policy = data.aws_iam_policy_document.eventbridge_pipe_policy_document.json
}

resource "aws_iam_role_policy" "eventbridge_pipe_sqs_iam_policy" {
  name   = "eventbridge-pipe-sqs"
  role   = aws_iam_role.eventbridge_pipe_sqs_role.id
  policy = data.aws_iam_policy_document.eventbridge_pipe_sqs_policy.json
}

resource "aws_iam_role" "lambda_role" {
  name               = "eventbridge-pipe-lambda"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_policy_document.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ]
}

resource "aws_iam_role" "pipe_dynamodb_role" {
  assume_role_policy = data.aws_iam_policy_document.eventbridge_pipe_policy_document.json
}

resource "aws_iam_role_policy" "pipe_dynamodb_iam_role_policy" {
  name = "eventbridge-pipe-dynamodb"
  role   = aws_iam_role.pipe_dynamodb_role.id
  policy = data.aws_iam_policy_document.eventbridge_pipe_dynamodb_policy.json
}