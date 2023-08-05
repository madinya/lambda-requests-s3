import os
from .get_data import get_from_url
from .s3 import upload_file

def lambda_handler(event, context):
    try:
        bucket_name = os.getenv("BUCKET")
        event["bucket_name"] = bucket_name
        request_response = get_from_url(event["url"])
        upload_file(file_content=request_response.content, **event)
        return {"statusCode": 200, "body": "Success!"}
    except Exception as ex:
         return {"statusCode": 500, "body": ex}
