# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'orm_adapter-guacamole/version'

Gem::Specification.new do |spec|
  spec.name          = 'orm_adapter-guacamole'
  spec.version       = OrmAdapter::Guacamole::VERSION
  spec.authors       = ['Klaus 21x2']
  spec.email         = ['klaus_21x2@twentyonetwice.com']

  spec.summary       = 'ORM Adapter for guacamole, the ODM for the NoSQL database ArangoDB'
  spec.description   = 'ORM Adapter for guacamole'
  spec.homepage      = 'https://github.com/twentyonetwice/orm_adapter-guacamole'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{'^(test|spec|features)/'}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'orm_adapter', '~> 0.5.0'
  spec.add_dependency 'guacamole', '~> 0.4.0'

  spec.add_development_dependency 'bundler', '~> 1.8'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.2.0', '>= 3.2.0'
  spec.add_development_dependency 'guard', '~> 2.12.4', '>= 2.12.4'
  spec.add_development_dependency 'guard-rspec', '~> 4.4'
  spec.add_development_dependency 'guard-bundler', '~> 2.0'
  spec.add_development_dependency 'pry', '~> 0.10.1'

end
