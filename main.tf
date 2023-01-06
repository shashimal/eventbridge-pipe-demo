locals {
  sqs_enrichment_input_template = "{\"item\": \"<$.body.itemName>\",\"qty\": \"<$.body.orderQty>\", \"price\" : \"<$.body.ItemPrice>\"}"
  filters                       = [
    {
      Pattern : "{\"body\" :  { \"orderQty\": [{ \"numeric\": [\">\", 10] }] } }"
    }
  ]

  #[ { pattern = "{\"body\" :  { \"orderQty\": [{ \"numeric\": [\">\", 20] }] } }" } ]
  aft_modify_event_filters = [{ pattern = "{ \"eventName\": [\"MODIFY\"] }" }]


  dynamodb_enrichment_input_template = "{ \"eventName\": <$.eventName>,  \"newObject\":  <$.dynamodb.NewImage.custom_fields.S> , \"oldObject\":  <$.dynamodb.OldImage.custom_fields.S>}"
}

#module "pipe_sqs" {
#  source = "./modules/pipe-sqs"
#  pipe_name = "order-sqs-pipe"
#  pipe_role_arn = aws_iam_role.eventbridge_pipe_sqs_role.arn
#  pipe_source_arn = aws_sqs_queue.customer_order_sqs.arn
#  pipe_enrichment_arn = module.order_process_lambda.lambda_function_arn
#  pipe_target_arn = module.order_invoice_lambda.lambda_function_arn
#  input_transform_template = local.sqs_enrichment_input_template
#  source_filters = local.filters
#}

module "pipe_dynamodb" {
  source                   = "./modules/pipe-dynamodb"
  pipe_name                = "order-dynamodb-pipe"
  pipe_role_arn            = aws_iam_role.pipe_dynamodb_role.arn
  pipe_source_arn          = aws_dynamodb_table.order_info.stream_arn
  pipe_enrichment_arn      = module.aft_process_lambda.lambda_function_arn
  pipe_target_arn          = module.order_invoice_lambda.lambda_function_arn
  input_transform_template = local.dynamodb_enrichment_input_template
  source_filters           = local.aft_modify_event_filters
}

