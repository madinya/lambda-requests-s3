import requests
from .downloader import Downloader
class RequestsDownloader(Downloader):

    def __init__(self) -> None:
        super().__init__()

    @classmethod
    def download(cls, **kwargs):
        url = kwargs["url"]
        if not url: 
            raise Exception('Url were not provided')
        return requests.get(url)