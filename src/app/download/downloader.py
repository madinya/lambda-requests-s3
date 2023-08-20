from abc import ABC, abstractmethod

class Downloader(ABC):
    
    def __init__(self) -> None:
        super().__init__()
    
    @classmethod
    @abstractmethod
    def download(cls, **kwargs):
        pass