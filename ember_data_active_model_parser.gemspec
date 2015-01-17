# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ember_data_active_model_parser/version'

Gem::Specification.new do |spec|
  spec.name          = "ember_data_active_model_parser"
  spec.version       = EmberDataActiveModelParser::VERSION
  spec.authors       = ["Valentin Mihov"]
  spec.email         = ["valentin.mihov@gmail.com"]
  spec.summary       = %q{A parser for Her compatible with ember-data's active_model_serializers format}
  spec.description   = %q{A parser that enables Her to consume data exposed through active_model_serializers and compatible with the ember-data format}
  spec.homepage      = "https://github/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "her"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
