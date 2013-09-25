# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require File.expand_path('../lib/social_rebate/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "social_rebate"
  spec.version       = SocialRebate::VERSION
  spec.authors       = ["daifu"]
  spec.email         = ["daifu.ye@gmail.com"]
  spec.description   = %q{This is the api wrapper for social rebate}
  spec.summary       = %q{Social Rebate}
  spec.homepage      = "https://github.com/daifu/social_rebate_api_wrapper"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", ">= 2.11.0"
  spec.add_development_dependency "debugger"

  spec.add_dependency "httparty", ">= 0.9.0"
  spec.add_dependency "json"    , "~> 1.7.0"

end
