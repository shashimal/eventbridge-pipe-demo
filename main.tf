locals {
  filter_pattern            = " {\"body\" :  { \"orderQty\": [{ \"numeric\": [\">\", 10] }] } }"
  enrichment_input_template = "{\"orderQty\": \"<$.body.orderQty>\", \"price\" : \"<$.body.orderPrice>\"}"
}

resource "aws_cloudformation_stack" "eventbridge_pipe_stack" {
  name       = "EventBridgePipeStack"
  parameters = {
    RoleArn       = aws_iam_role.eventbridge_pipe_sqs_role.arn
    SourceArn     = aws_sqs_queue.article_sqs.arn
    EnrichmentArn = module.eventbridge_pipe_enrichment_lambda.lambda_function_arn
    TargetArn     = module.eventbridge_pipe_target_lambda.lambda_function_arn
    FilterPattern = local.filter_pattern
    InputTemplate = local.enrichment_input_template
  }

  template_body = jsonencode({
    "Parameters" : {
      "SourceArn" : {
        "Type" : "String",
      },
      "EnrichmentArn" : {
        "Type" : "String",
      },
      "TargetArn" : {
        "Type" : "String",
      },
      "RoleArn" : {
        "Type" : "String"
      },
      "FilterPattern" : {
        "Type" : "String"
      },
      "InputTemplate" : {
        "Type" : "String"
      }
    },
    "Resources" : {
      "CopyPipe" : {
        "Type" : "AWS::Pipes::Pipe",
        "Properties" : {
          "Name" : "EventBridgePipeDemo",
          "RoleArn" : { "Ref" : "RoleArn" },
          "Source" : { "Ref" : "SourceArn" },
          "SourceParameters" : {
            "FilterCriteria" : {
              "Filters" : [
                {
                  "Pattern" : { "Ref" : "FilterPattern" },
                }
              ]
            }
          },
          "Enrichment" : { "Ref" : "EnrichmentArn" },
          "EnrichmentParameters" : {
            "InputTemplate" : { "Ref" : "InputTemplate" },
          }
          "Target" : { "Ref" : "TargetArn" }
        }
      }
    }
  })
}


