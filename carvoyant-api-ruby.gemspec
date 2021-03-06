# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'carvoyant_api/version'

Gem::Specification.new do |spec|
  spec.name          = "carvoyant-api-ruby"
  spec.version       = CarvoyantAPI::VERSION
  spec.authors       = ["Farrukh Abdulkadyrov"]
  spec.email         = ["farrukhabdul@gmail.com"]
  spec.summary       = %q{The Carvoyant API gem is a lightweight gem for accessing Carvoyant REST services}
  spec.description   = %q{The Carvoyant API gem allows Ruby developers to programmatically access the Carvoyant Resources. The API is implemented as JSON over HTTP using all four verbs (GET/POST/PUT/DELETE). Each resource, like Vehicle, Trip, or DataSet, has its own URL and is manipulated in isolation.}
  spec.homepage      = "http://younility.com/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'activeresource', '~> 4.0', '>= 4.0.0'
  spec.add_dependency 'ruby-units', '~> 1.4.5', '>= 1.4.5'

  spec.add_development_dependency "bundler", "~> 1.6"

  dev_dependencies = [['mocha', '~> 0.9.8', '>= 0.9.8'],
                      ['fakeweb', '~> 1.3.0', '>= 1.3.0'],
                      ['minitest', '~> 5.8.0', '>= 5.8.0'],
                      ['rake', '~> 10.4.2', '>= 10.4.2'],
                      ['byebug', '~> 6.0.2', '>= 6.0.2'],
                      ['timecop', '~> 0.8.0', '>= 0.8.0']
  ]

  if spec.respond_to?(:add_development_dependency)
    dev_dependencies.each { |dep| spec.add_development_dependency(*dep) }
  else
    dev_dependencies.each { |dep| spec.add_dependency(*dep) }
  end
end
