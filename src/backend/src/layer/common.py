import os
import json
import requests
import boto3
from botocore.exceptions import ClientError

# グローバル変数（定数）
S3_BUCKET_NAME = os.environ.get('S3_BUCKET_NAME')
SMS_PHONE_NUMBER = os.environ.get('SMS_PHONE_NUMBER')
MOBILE_APP_ARN = os.environ.get('MOBILE_APP_ARN')

# S3とSNSクライアント
S3_CLIENT = boto3.client('s3')
SNS_CLIENT = boto3.client('sns')

# ログ出力関数


def log_event(event):
    print("Received event: " + json.dumps(event, indent=2))

# レスポンス作成関数


def create_response(status_code, body):
    return {
        'statusCode': status_code,
        'body': json.dumps(body)
    }


def get_query_params(event):
    return event.get('queryStringParameters', {})


def get_request_body(event):
    if 'body' in event and event.get('body') is not None:
        return json.loads(event.get('body', {}))
    else:
        return {}


def get_request_headers(event):
    return event.get('headers', {})


def get_path_params(event):
    return event.get('pathParameters', {})


def fetch_external_site(url):
    response = requests.get(url)
    return response.content


def upload_to_s3(key, data):
    try:
        S3_CLIENT.put_object(Bucket=S3_BUCKET_NAME, Key=key, Body=data)
    except ClientError as e:
        print(e)
        return False
    return True


def download_from_s3(key):
    try:
        response = S3_CLIENT.get_object(Bucket=S3_BUCKET_NAME, Key=key)
        return response['Body'].read()
    except ClientError as e:
        print(e)
        return None


def send_sms(message):
    try:
        response = SNS_CLIENT.publish(
            PhoneNumber=SMS_PHONE_NUMBER,
            Message=message
        )
    except ClientError as e:
        print(e)
        return False
    return True


def send_mobile_push(message):
    try:
        response = SNS_CLIENT.publish(
            TargetArn=MOBILE_APP_ARN,
            Message=message
        )
    except ClientError as e:
        print(e)
        return False
    return True
