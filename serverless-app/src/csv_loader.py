import logging
import boto3

logger = logging.getLogger()
logger.setLevel(logging.INFO)

s3 = boto3.client('s3', endpoint_url="http://localhost:4566")
dynamodb = boto3.resource('dynamodb', region_name='us-east-1',
                        aws_access_key_id="test", aws_secret_access_key="test",
                        endpoint_url='http://localhost:4566')
table = dynamodb.Table('my-dynamodb-for-assignment')

def lambda_handler(event, context):

    # retrieve bucket name and file_key from the S3 event
    bucket_name = event['Records'][0]['s3']['bucket']['name']
    file_key = event['Records'][0]['s3']['object']['key']
    logger.info('Reading {} from {}'.format(file_key, bucket_name))
    resp = s3.get_object(Bucket=bucket_name,Key=file_key)
    data = resp['Body'].read().decode('utf-8')
    print(data)
    csv_file_content = data.split("\n")
    print(csv_file_content)
    for file in csv_file_content:
        print(file)
        table.put_item(
            Item={'id': context.aws_request_id,
                  'csv_file_name': file_key,
                  'csv_file_content': str(csv_file_content)
                  }
                  )
