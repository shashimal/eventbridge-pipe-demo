resource "aws_cloudformation_stack" "this" {
  name = "${var.pipe_name}-stack"

  parameters = {
    RoleArn       = var.pipe_role_arn
    SourceArn     = var.pipe_source_arn
    TargetArn     = var.pipe_target_arn
    EnrichmentArn = var.pipe_enrichment_arn
    InputTemplate = var.input_transform_template
  }

  template_body = jsonencode({
    "Parameters" : {
      "SourceArn" : {
        "Type" : "String",
      },
      "TargetArn" : {
        "Type" : "String",
      },
      "RoleArn" : {
        "Type" : "String"
      },
      "InputTemplate" : {
        "Type" : "String"
      },
      "EnrichmentArn" : {
        "Type" : "String",
      }
    },

    "Resources" : {
      "CopyPipe" : {
        "Type" : "AWS::Pipes::Pipe",
        "Properties" : {
          "Name" : var.pipe_name,
          "RoleArn" : { "Ref" : "RoleArn" },
          "Source" : { "Ref" : "SourceArn" },
          "SourceParameters" : {
            "FilterCriteria" : {
              "Filters" : var.source_filters,
            },
            "DynamoDBStreamParameters": {
              "BatchSize": var.batch_size,
              "StartingPosition": var.starting_position
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