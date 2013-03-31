require File.expand_path("../lib/notarize/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "notarize"
  s.version     = Notarize::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Aaron Klaassen"]
  s.email       = ["aaron@outerspacehero.com"]
  s.homepage    = "http://www.outerspacehero.com/"
  s.summary     = "A simple library for generating and checking signed http requests."
  s.description = "A simple library for generating and checking signed http requests."

  s.files        = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
  s.require_path = 'lib'

  s.add_development_dependency "rspec"
end