import os
from .requests_downloader import RequestsDownloader
from .s3_uploader import AwsUploader

def lambda_handler(event, context):
    try:
        bucket_name = os.getenv("BUCKET")
        event["bucket_name"] = bucket_name
        request_response = RequestsDownloader.download(**event)
        event["file_content"] = request_response.content
        AwsUploader.upload(**event)
        return {"statusCode": 200, "body": "Success!"}
    except Exception as ex:
         return {"statusCode": 500, "body": ex}
