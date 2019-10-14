# sdk:node (javascript)

Note: for browser, see [here](./src/integrations/browser#readme).

Basic usage:

```
const pdsdk = require("@pipedreamhq/sdk")

pdsdk.sendEvent(API_KEY, {
  timestamp: +new Date(),
})
```

The payload will be exported as event and raw_event.  If you would like to add an
export, or override the `event` export:

```
pdsdk.sendEvent(API_KEY, {
  timestamp: +new Date(),
  raw_event: true
}, {
  exports: {
    event: {
      timestamp: new Date().toString(),
    },
    other_export: "hello"
  },
})
```

If you do not provide an `event` it will be the same as `raw_event` (first argument). `raw_event` and `event` MUST be an object or
the SDK request will be rejected as invalid.
