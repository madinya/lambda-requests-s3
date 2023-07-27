import requests

def get_from_url(url:str, **kwargs):
    if not url: 
        raise Exception('Url were not provided')
    return requests.get(url)