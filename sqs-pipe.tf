locals {
  article_event_filters = [{ pattern = "{ \"copyright\": [\"SPH\"] }" }]
  article_enrichment_input_template = "{\"id\": \"<$.body.articleId>\",\"headLine\": \"<$.body.head_line>\", \"date\" : \"<$.body.publishedDate>\"}"
}

module "sqs_pipe" {
  source                   = "./modules/pipe-sqs"

  pipe_name                = "sqs-pipe"
  pipe_role_arn            = aws_iam_role.eventbridge_pipe_sqs_role.arn
  pipe_source_arn          = aws_sqs_queue.st_article_sqs.arn
  source_filters           = local.article_event_filters
  pipe_enrichment_arn      = module.order_process_lambda.lambda_function_arn
  input_transform_template = local.article_enrichment_input_template
  pipe_target_arn          = module.order_invoice_lambda.lambda_function_arn
}

