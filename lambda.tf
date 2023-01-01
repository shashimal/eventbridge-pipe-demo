

module "order_invoice_lambda" {
  source = "terraform-aws-modules/lambda/aws"

  function_name          = "order-invoice"
  source_path            = "${path.module}/lambda-handler/order-invoice"
  handler                = "index.handler"
  runtime                = "nodejs18.x"
  local_existing_package = "${path.module}/lambda-handler/order-invoice/index.zip"
  create_role            = false
  lambda_role            = aws_iam_role.lambda_role.arn
}


module "order_process_lambda" {
  source = "terraform-aws-modules/lambda/aws"

  function_name          = "order-process"
  source_path            = "${path.module}/lambda-handler/order-process"
  handler                = "index.handler"
  runtime                = "nodejs18.x"
  local_existing_package = "${path.module}/lambda-handler/order-process/index.zip"
  create_role            = false
  lambda_role            = aws_iam_role.lambda_role.arn
}