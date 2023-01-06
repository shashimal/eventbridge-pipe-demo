resource "aws_sqs_queue" "st_article_sqs" {
  name = "st-articles"
}

resource "aws_dynamodb_table" "aft-request" {
  name           = "aft-request"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "Id"
  stream_enabled = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "Id"
    type = "S"
  }
}
