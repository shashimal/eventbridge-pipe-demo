resource "awscc_pipes_pipe" "pipe" {
  name     = var.pipe_name
  role_arn = var.pipe_role_arn
  source   = var.pipe_source_arn

  source_parameters = {
    filter_criteria = {
      filters = var.source_filters
    }
  }

  enrichment            = var.pipe_enrichment_arn
  enrichment_parameters = {
    input_template = var.input_transform_template
  }

  target = var.pipe_target_arn
}
