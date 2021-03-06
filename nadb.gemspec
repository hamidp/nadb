# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nadb/version'

Gem::Specification.new do |spec|
  spec.name          = "nadb"
  spec.version       = Nadb::VERSION
  spec.authors       = ["Hamid Palo"]
  spec.email         = ["hamid.palo@gmail.com"]
  spec.summary       = %q{A nicer interface for adb}
  spec.description   = %q{}
  spec.homepage      = "https://github.com/hamidp/nadb"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
