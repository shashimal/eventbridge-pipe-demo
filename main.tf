locals {
  filter_pattern            = " {\"body\" :  { \"orderQty\": [{ \"numeric\": [\">\", 10] }] } }"
  enrichment_input_template = "{\"item\": \"<$.body.itemName>\",\"qty\": \"<$.body.orderQty>\", \"price\" : \"<$.body.ItemPrice>\"}"
  filters = [
    {
      Pattern: "{\"body\" :  { \"orderQty\": [{ \"numeric\": [\">\", 10] }] } }"
    }
  ]
}

#resource "aws_cloudformation_stack" "customer_order_pipe_stack" {
#  name       = "customer-order-pipe-stack"
#
#  parameters = {
#    RoleArn       = aws_iam_role.eventbridge_pipe_sqs_role.arn
#    SourceArn     = aws_sqs_queue.customer_order_sqs.arn
#    EnrichmentArn = module.order_process_lambda.lambda_function_arn
#    TargetArn     = module.order_invoice_lambda.lambda_function_arn
#    FilterPattern = local.filter_pattern
#    InputTemplate = local.enrichment_input_template
#  }
#
#  template_body = jsonencode({
#    "Parameters" : {
#      "SourceArn" : {
#        "Type" : "String",
#      },
#      "EnrichmentArn" : {
#        "Type" : "String",
#      },
#      "TargetArn" : {
#        "Type" : "String",
#      },
#      "RoleArn" : {
#        "Type" : "String"
#      },
#      "FilterPattern" : {
#        "Type" : "String"
#      },
#      "InputTemplate" : {
#        "Type" : "String"
#      }
#    },
#
#    "Resources" : {
#      "CopyPipe" : {
#        "Type" : "AWS::Pipes::Pipe",
#        "Properties" : {
#          "Name" : "customer-order",
#          "RoleArn" : { "Ref" : "RoleArn" },
#          "Source" : { "Ref" : "SourceArn" },
#          "SourceParameters" : {
#            "FilterCriteria" : {
#              "Filters" : [
#                {
#                  "Pattern" : { "Ref" : "FilterPattern" },
#                }
#              ]
#            }
#          },
#          "Enrichment" : { "Ref" : "EnrichmentArn" },
#          "EnrichmentParameters" : {
#            "InputTemplate" : { "Ref" : "InputTemplate" },
#          }
#          "Target" : { "Ref" : "TargetArn" }
#        }
#      }
#    }
#  })
#}

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

