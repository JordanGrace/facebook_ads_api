# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'facebook_ads_api/version'

Gem::Specification.new do |spec|
  spec.name          = "facebook_ads_api"
  spec.version       = FacebookAdsApi::VERSION
  spec.authors       = ["Bill Watts"]
  spec.email         = ["william.lane.watts@gmail.com"]
  spec.description   = %q{A simple library for communicating with the Facebook Ads API}
  spec.summary       = %q{A simple library for communicating with the Facebook Ads API}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_runtime_dependency "multi_json"
end
