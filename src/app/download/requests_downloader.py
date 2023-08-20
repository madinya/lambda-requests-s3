import requests

from .downloader import Downloader


class RequestsDownloader(Downloader):
    @classmethod
    def download(cls, **kwargs):
        url = kwargs["url"]
        if not url:
            raise Exception("Url were not provided")
        return requests.get(url)
