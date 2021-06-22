#!/bin/bash

## Description : This script is testing serverless project in locally by using localstack.
## Terraform, aws cli and docker should be installed local machine.Download source project and run it.
## Usage: bash test.sh [options] CSV_FILE_PATH
## Author : ardasendur
##


#Constants
S3_BUCKET_NAME="my-s3-bucket-for-assignment"
LAMBDA_LOG_GROUP="/aws/lambda/csv-loader"
TABLE_NAME="my-dynamodb-for-assignment"
CSV_FILE_PATH=$1

upload_csv_file_s3()
{
  aws s3 ls --endpoint-url=http://localhost:4566
  aws s3 cp $CSV_FILE_PATH s3://$S3_BUCKET_NAME --endpoint-url=http://localhost:4566
}
tail_lambda_log()
{
  aws --endpoint-url=http://localhost:4566 logs tail $LAMBDA_LOG_GROUP > test/test_output/lambda_output
}
check_dynamodb_table()
{
  aws dynamodb scan --table-name $TABLE_NAME --endpoint-url=http://localhost:4566 > test/test_output/scan_output
  cat test/test_output/scan_output
}
clean_up_env(){
  docker stop localstack
  rm -rf terraform.tfstate .terraform .terraform.lock.hcl
}
init(){
  mkdir test_output
  docker run --rm -itd -p 4566:4566 -p 4571:4571 --name localstack localstack/localstack
  cd ..
  sleep 7
  terraform init
  terraform plan -var-file="app.tfvars" -out plan_output
  terraform apply -var-file="app.tfvars" -auto-approve
  upload_csv_file_s3
  tail_lambda_log
  check_dynamodb_table
  clean_up_env

}
 main(){
   init
 }
 main "$@"
