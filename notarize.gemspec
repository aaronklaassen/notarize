require File.expand_path("../lib/notarize/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "notarize"
  s.version     = Notarize::VERSION
  s.authors     = ["Aaron Klaassen"]
  s.email       = ["aaron@outerspacehero.com"]
  s.homepage    = "http://www.github.com/aaronklaassen/notarize/"
  s.summary     = "A simple library for generating signed http requests."
  s.description = "For basic web services that don't want just anyone to have access. Generates signature hashes for http requests."

  s.files        = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
  s.require_path = 'lib'

  s.add_dependency "httparty"

  s.add_development_dependency "rspec"
end