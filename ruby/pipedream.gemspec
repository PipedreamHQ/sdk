$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require "pipedream/version"

Gem::Specification.new do |g|
  g.name = "pipedream"
  g.version = Pipedream::VERSION
  g.date = "2019-10-14"
  g.summary = g.description = "Pipedream SDK"
  g.authors = ["Pipedream Team"]
  g.email = "engineering@pipedream.com"
  g.files = `git ls-files`.split("\n")
  g.homepage = "https://github.com/PipedreamHQ/sdk/blob/master/ruby"
  g.license = "MIT"
  g.add_development_dependency "keycutter"
  g.metadata = {"github_repo" => "ssh://github.com/PipedreamHQ/sdk"}
end
