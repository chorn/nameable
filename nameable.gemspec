# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nameable/version'

Gem::Specification.new do |spec|
  spec.name          = 'nameable'
  spec.version       = Nameable::VERSION
  spec.authors       = ['Chris Horn']
  spec.email         = ['chorn@chorn.com']
  spec.summary       = 'Parse names into components.'
  spec.description   = 'A library that provides parsing and output of person names, as well as Gender & Ethnicity matching.'
  spec.homepage      = 'https://github.com/chorn/nameable'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  signing_key = File.expand_path("~/.certs/chorn@chorn.com-rubygems.key")
  if File.file?(signing_key)
    spec.signing_key = signing_key
    spec.cert_chain = ['certs/chorn.pem']
  end

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'codeclimate-test-reporter', '~> 0.4'
  spec.add_development_dependency 'guard', '~> 2.12'
  spec.add_development_dependency 'guard-bundler', '~> 2.1'
  spec.add_development_dependency 'guard-rspec', '~> 4.5'
  spec.add_development_dependency 'rake', '~> 10.4'
  spec.add_development_dependency 'rspec', '~> 3.3'
end
