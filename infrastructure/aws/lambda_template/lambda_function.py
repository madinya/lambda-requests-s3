def lambda_handler(event, context):
    try:
        return {"statusCode": 200, "body": "Success!"}
    except Exception as ex:
        return {"statusCode": 500, "body": ex}
    