# sdk:ruby

```ruby
require "pdsdk"

Pdsdk.send_event(API_KEY, hello: "world")

# with exports
Pdsdk.send_event(API_KEY, {
  hello: "world"
}, exports: {
  event: { hello: "world!" },
  other_export: "howdy",
})
```

If you do not provide an `event` export it will be set to the `raw_event` (first argument).  `event` and `raw_event` MUST be a hash or the SDK request will be invalid.

## Development

Setup: https://help.github.com/en/articles/configuring-rubygems-for-use-with-github-package-registry#authenticating-to-github-package-registry

To cut new version (TODO automate this):

```
# update lib/pdsdk/version.rb to $VERSION
gem build pdsdk.gemspec
gem push pdsdk-$VERSION.gem
```
