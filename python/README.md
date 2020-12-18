# sdk:python

## Usage

```python
from pipedream_sdk import send_event

send_event({'hello': 'world'})

# with exports
send_event(
    {'hello': 'world'},
    exports={
        'event': {'hello': 'world!'},
        'other_export': 'howdy',
    }
)
```

Importing `send_event` directly will create an instance of `PipedreamSdkClient`
behind the scenes, configured through environment variables. You may also create
the client explicitly:

```python
from pipedream_sdk import PipedreamSdkClient

pd = PipedreamSdkClient(
    api_key=YOUR_API_KEY,
    sdk_protocol='https',
)
pd.send_event({'hello': 'world'})
```

This may be useful in cases where multiple events need to be pushed to Pipedream
using differing API keys, or where some events should be sent as over HTTPS while
others should be sent without SSL.

## Development

TODO
