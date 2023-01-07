locals {
  aft_modify_event_filters = [{ pattern = "{ \"eventName\": [\"MODIFY\"] }" }]
  aft_enrichment_input_template = "{ \"eventName\": <$.eventName>,  \"newCustomFields\":  <$.dynamodb.NewImage.custom_fields.S> , \"oldCustomFields\":  <$.dynamodb.OldImage.custom_fields.S>}"
  app_name = "dynamodb-pipe"
}

module "dynamodb_pipe" {
  source                   = "./modules/pipe-dynamodb"

  pipe_name                = local.app_name
  pipe_role_arn            = aws_iam_role.pipe_dynamodb_role.arn
  pipe_source_arn          = aws_dynamodb_table.aft-request.stream_arn
  source_filters           = local.aft_modify_event_filters
  pipe_enrichment_arn      = module.aft_process_lambda.lambda_function_arn
  input_transform_template = local.aft_enrichment_input_template
  pipe_target_arn          = module.order_invoice_lambda.lambda_function_arn
}

