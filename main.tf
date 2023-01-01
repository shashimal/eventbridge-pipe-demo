locals {
  enrichment_input_template = "{\"item\": \"<$.body.itemName>\",\"qty\": \"<$.body.orderQty>\", \"price\" : \"<$.body.ItemPrice>\"}"
  filters = [
    {
      Pattern: "{\"body\" :  { \"orderQty\": [{ \"numeric\": [\">\", 10] }] } }"
    }
  ]
}

module "pipe_sqs" {
  source = "./modules/pipe"
  pipe_name = "order-sqs-pipe"
  pipe_role_arn = aws_iam_role.eventbridge_pipe_sqs_role.arn
  pipe_source_arn = aws_sqs_queue.customer_order_sqs.arn
  pipe_enrichment_arn = module.order_process_lambda.lambda_function_arn
  pipe_target_arn = module.order_invoice_lambda.lambda_function_arn
  input_transform_template = local.enrichment_input_template
  source_filters = local.filters
}

