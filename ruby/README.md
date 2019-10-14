# sdk:ruby

```ruby
require "pipedream"

Pipedream.send_event(API_KEY, hello: "world")

# with exports
Pipedream.send_event(API_KEY, {
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
# update lib/pipedream/version.rb to $VERSION
gem build pipedream.gemspec
gem push --key github --host https://rubygems.pkg.github.com/PipedreamHQ pipedream-$VERSION.gem
```
