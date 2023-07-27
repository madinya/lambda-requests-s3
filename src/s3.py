import boto3


def upload_file(file_content, file_name:str, extension: str,  bucket_folder:str, bucket_name:str, **kwargs):
    if not file_name:
        raise Exception('Not filename were provided to save the file') 
    if not bucket_folder:
        raise Exception('Not folder were provided to save the file') 
    if not bucket_name:
        raise Exception('Not bucket_name were provided to save the file') 
        
    s3 = boto3.client('s3')
    s3.put_object(Bucket=bucket_name, Key=f'{bucket_folder}/{file_name}.{extension}', Body=file_content)