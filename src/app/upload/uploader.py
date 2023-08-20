from abc import ABC, abstractmethod

class Uploader(ABC):
    
    def __init__(self) -> None:
        super().__init__()

    @classmethod
    @abstractmethod
    def upload(cls, **kwargs):
        pass