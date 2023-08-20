from lambda_function import lambda_handler

if __name__ == "__main__":
    import datetime

    param = {
        "url": "https://data.gharchive.org/2015-01-01-15.json.gz",
        "bucket_folder": "gharchive-1",
        "file_name": f"test_{datetime.datetime.now()}",
        "extension": "json.gz",
    }

    print(lambda_handler(param, None))
