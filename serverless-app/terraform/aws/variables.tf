variable "dynamodb_name" {
  default = ""
}


variable "bucket_name" {
  default = ""
}

variable "lambda_handler" {
  default = "csv_loader.lambda_handler"
}
variable "function_name" {
  default = ""
}
variable "lambda_description" {
  default = "This lambda function load CSV file from S3 to DynamoDB"
}
variable "lambda_run_time" {
  default = "python3.8"
}
variable "source_path" {
  default = "../../src/csv_loader.py"
}