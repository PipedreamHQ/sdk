from .client import PipedreamSdkClient


_CLIENT = None


def _get_client():
    global _CLIENT

    if _CLIENT is None:
        _CLIENT = PipedreamSdkClient()
    return _CLIENT


def send_event(*args, **kwargs):
    _get_client().send_event(*args, **Jkwargs)
