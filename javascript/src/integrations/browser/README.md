# pdsdk:browser (javascript)

Note: ad blockers, please only block sdk.pipedream.net (other domains
will break non-tracking pipedream functionality).

Insert [this snippet](../../../dist/snippet.html) into your page, and then --

```javascript
pdsdk.sendEvent(API_KEY, {
  timestamp: +new Date(),
})
```

## TODO

- capture console errors, etc.
