# sdk:python

```python
from pipedream import sdk as pd

pd.send_event(API_KEY, {'hello': 'world'})

# with exports
pd.send_event(
    API_KEY,
    {'hello': 'world'},
    exports={
        'event': {'hello': 'world!'},
        'other_export': 'howdy',
    }
)
```

If you do not provide an `event` export it will be set to the `raw_event`
(first argument).  `event` and `raw_event` MUST be a dict or the SDK request
will be invalid.

## Development

TODO
