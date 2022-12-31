data "aws_iam_policy_document" "eventbridge_pipe_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["pipes.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "eventbridge_pipe_sqs_policy" {
  statement {
    sid = "InvokeLambda"
    actions = ["lambda:InvokeFunction"]
    resources = ["*"]
  }
  statement {
    sid = "AccessSQS"
    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "lambda_assume_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "archive_file" "order_process_lambda_file" {
  type        = "zip"
  source_file = "${path.module}/lambda-handler/order-process/index.mjs"
  output_path = "${path.module}/lambda-handler/order-process/index.zip"
}

data "archive_file" "order_invoice_file" {
  type        = "zip"
  source_file = "${path.module}/lambda-handler/order-invoice/index.mjs"
  output_path = "${path.module}/lambda-handler/order-invoice/index.zip"
}