from abc import ABC, abstractmethod

class Uploader(ABC):

    @classmethod
    @abstractmethod
    def upload(cls, **kwargs):
        pass