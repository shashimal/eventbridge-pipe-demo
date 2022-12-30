

module "eventbridge_pipe_target_lambda" {
  source = "terraform-aws-modules/lambda/aws"

  function_name          = "pipe-target-lambda"
  source_path            = "${path.module}/lambda-handler/target"
  handler                = "index.handler"
  runtime                = "nodejs18.x"
  local_existing_package = "${path.module}/lambda-handler/target/index.zip"
  create_role            = false
  lambda_role            = aws_iam_role.lambda_role.arn
}


module "eventbridge_pipe_enrichment_lambda" {
  source = "terraform-aws-modules/lambda/aws"

  function_name          = "pipe-enrichment-lambda"
  source_path            = "${path.module}/lambda-handler/enrichment"
  handler                = "index.handler"
  runtime                = "nodejs18.x"
  local_existing_package = "${path.module}/lambda-handler/enrichment/index.zip"
  create_role            = false
  lambda_role            = aws_iam_role.lambda_role.arn
}