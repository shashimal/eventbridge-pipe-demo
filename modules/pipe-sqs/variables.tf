variable "pipe_name" {
  description = "EventBridge pipe name"
  type = string
}

variable "pipe_source_arn" {
  description = "Source arn (SQS, DynamoDB etc)"
  type = string
}

variable "pipe_enrichment_arn" {
  description = "Enrichment arn (Lambda, API Gateway etc)"
  type = string
  default = ""
}

variable "pipe_target_arn" {
  description = "Target arn (Lambda, API Gateway etc)"
  type = string
}

variable "pipe_role_arn" {
  description = "IAM role arn"
  type = string
}

variable "source_filters" {
  description = "Filter pattern to filter events from source"
  type = list(object({
    pattern = string
  }))
  default = []
}

variable "input_transform_template" {
  description = "Template to transform source inputs"
  type = string
  default = ""
}