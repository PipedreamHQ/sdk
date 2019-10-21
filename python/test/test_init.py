import pipedream_sdk as sdk


# TODO: This should really only test that an instance of the client was created
def test_client_config():
    sdk._CLIENT = None
    client = sdk._get_client()

    assert client._api_key is None
    assert client._sdk_host == 'sdk.m.pipedream.net'
    assert client._sdk_protocol == 'https'
