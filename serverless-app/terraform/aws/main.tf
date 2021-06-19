
# Configure the AWS Provider for local stack
provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  s3_force_path_style         = true
  access_key                  = "test"
  secret_key                  = "test"
   endpoints {
        sqs               = "http://localhost:4566"
        s3                = "http://localhost:4566"
        lambda            = "http://localhost:4566"
        dynamodb          = "http://localhost:4566"
        sts               = "http://localhost:4566"
        secretsmanager    = "http://localhost:4566"
        iam               = "http://localhost:4566"
        cloudwatch        = "http://localhost:4566"
        cloudwatchlogs    = "http://localhost:4566"
    }
}

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"
  bucket = var.bucket_name
  versioning = {
    enabled = true
  }

}

module "lambda_function" {
  source        = "terraform-aws-modules/lambda/aws"
  function_name = var.function_name
  description   = var.lambda_description
  handler       = var.lambda_handler
  runtime       = var.lambda_run_time

  source_path = var.source_path

  tags = {
    Name = var.function_name
  }
}


resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = module.s3_bucket.s3_bucket_id
  lambda_function {
    lambda_function_arn = module.lambda_function.lambda_function_arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "AWSLogs/"
    filter_suffix       = ".log"
  }

  depends_on = [module.lambda_function]
}


module "dynamodb_table" {
  source   = "terraform-aws-modules/dynamodb-table/aws"
  name     = var.dynamodb_name
  hash_key = "id"

  attributes = [
    {
      name = "id"
      type = "N"
    }
  ]
}
