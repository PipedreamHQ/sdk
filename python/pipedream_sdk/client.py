import hashlib
import json
import os

import requests

from .about import version


class PipedreamSdkClient:
    def __init__(self, api_key=None, api_secret=None, sdk_host=None, sdk_protocol=None):
        self._sdk_version = '0.3.0'
        self._api_key = api_key or os.getenv('PD_SDK_API_KEY')
        self._api_secret = api_secret or os.getenv('PD_SECRET_KEY')
        self._sdk_host = (
            sdk_host
            or os.getenv('PD_SDK_HOST')
            or 'sdk.m.pipedream.net'
        )
        self._sdk_protocol = (
            sdk_protocol
            or os.getenv('PD_SDK_PROTO')
            or 'https'
        )

    def send_event(self, raw_event, exports=None, deployment=None):
        """Send an event to the PipedreamHQ SDK

        :return: None
        """
        # Manually create the payload so a signature can be generated
        event = {'raw_event': raw_event}
        data = json.dumps(event)
        headers = {
            'content-type': 'application/json',
            'user-agent': f'pipedream-sdk:python/{version}',
            'x-pd-sdk-version': self._sdk_version,
        }

        if self._api_secret:
            headers['x-pd-sig'] = self._sign(data)
        # TODO: warn if no secret is present

        #TODO: raise exception if POST fails
        response = requests.post(self._request_uri(deployment), data=data, headers=headers)

    def _request_uri(self, deployment):
        uri_parts = [
            f'{self._sdk_protocol}://{self._sdk_host}',
            'pipelines',
            self._api_key,
        ]
        if deployment:
            uri_parts += ['deployments', deployment]
        uri_parts.append('events')
        return '/'.join(uri_parts)

    def _sign(self, data):
        sig = hashlib.sha256(self._api_secret.encode('utf-8'))
        sig.update(data.encode('utf-8'))
        return sig.hexdigest()

