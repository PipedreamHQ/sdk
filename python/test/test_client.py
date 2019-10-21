import pytest

from pipedream_sdk import PipedreamSdkClient as Client


class TestClient:
    @pytest.fixture
    def env_vars(self, monkeypatch):
        monkeypatch.setenv('PD_SDK_HOST', 'example.com')
        monkeypatch.setenv('PD_SDK_PROTO', 'telnet')
        monkeypatch.setenv('PD_SDK_API_KEY', 'not-a-real-key')

    def test_config(self):
        client = Client()

        assert client._api_key is None
        assert client._sdk_host == 'sdk.m.pipedream.net'
        assert client._sdk_protocol == 'https'

    def test_config_from_env_vars(self, env_vars):
        client = Client()

        assert client._api_key == 'not-a-real-key'
        assert client._sdk_host == 'example.com'
        assert client._sdk_protocol == 'telnet'

    def test_config_from_params(self, env_vars):
        client = Client(
            api_key='explicit-key',
            sdk_host='explicit.example.com',
            sdk_protocol='gopher',
        )

        assert client._api_key == 'explicit-key'
        assert client._sdk_host == 'explicit.example.com'
        assert client._sdk_protocol == 'gopher'
