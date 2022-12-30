locals {
  json = jsondecode(
    {
      "body" = {
        "orderQty" = [{ numeric = [">", 10] }]
      }
    }
  )
}

resource "aws_cloudformation_stack" "eventbridge_pipe_stack" {
  name       = "EventBridgePipeStack"
  parameters = {
    RoleArn       = aws_iam_role.eventbridge_pipe_sqs_role.arn
    SourceArn     = aws_sqs_queue.article_sqs.arn
    EnrichmentArn = module.eventbridge_pipe_enrichment_lambda.lambda_function_arn
    TargetArn     = module.eventbridge_pipe_target_lambda.lambda_function_arn
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
      }
    },
    "Resources" : {
      "CopyPipe" : {
        "Type" : "AWS::Pipes::Pipe",
        "Properties" : {
          "Name" : "EventBridgePipeDemo",
          "RoleArn" : { "Ref" : "RoleArn" }
          "Source" : { "Ref" : "SourceArn" },
          "SourceParameters" : {
            "FilterCriteria" : {
              "Filters" : [
                {
                  "Pattern" : local.json
                }
              ]
            }
          }
          "Enrichment" : { "Ref" : "EnrichmentArn" }
          "Target" : { "Ref" : "TargetArn" },
        }
      }
    }
  })
}


