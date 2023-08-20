import boto3

from .uploader import Uploader


class AwsUploader(Uploader):
    @classmethod
    def upload(self, **kwargs):
        if not kwargs["file_content"]:
            raise Exception("Not file_content were provided to save the file")
        if not kwargs["file_name"]:
            raise Exception("Not file_name were provided to save the file")
        if not kwargs["bucket_folder"]:
            raise Exception("Not bucket_folder were provided to save the file")
        if not kwargs["bucket_name"]:
            raise Exception("Not bucket_name were provided to save the file")
        if not kwargs["extension"]:
            raise Exception("Not extension were provided to save the file")

        s3 = boto3.client("s3")
        s3.put_object(
            Bucket=kwargs["bucket_name"],
            Key=f'{kwargs["bucket_folder"]}/{kwargs["file_name"]}.{kwargs["extension"]}',
            Body=kwargs["file_content"],
        )
