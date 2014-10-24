# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'towerdata_email/version'

Gem::Specification.new do |spec|
  spec.name          = "towerdata_email"
  spec.version       = TowerdataEmail::VERSION
  spec.authors       = ["JanBussieck"]
  spec.email         = ["jan.bussieck@gmail.com"]
  spec.summary       = %q{Uses TowerData or any other EmailAPI to validate emails}
  spec.description   = %q{get_lead data using the TowerData API}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activemodel"
  spec.add_dependency "httparty"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "httparty"

end
