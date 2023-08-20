from abc import ABC, abstractmethod


class Downloader(ABC):
    @classmethod
    @abstractmethod
    def download(cls, **kwargs):
        pass
