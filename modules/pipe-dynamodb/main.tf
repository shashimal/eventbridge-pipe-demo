resource "awscc_pipes_pipe" "pipe" {
  name              = var.pipe_name
  role_arn          = var.pipe_role_arn
  source            = var.pipe_source_arn
  source_parameters = {
    dynamo_db_stream_parameters = {
      starting_position = var.starting_position
    },
    filter_criteria  = {
      filters = [ { pattern = "{\"body\" :  { \"orderQty\": [{ \"numeric\": [\">\", 20] }] } }" } ]
    }
  }
  target = var.pipe_target_arn
}
