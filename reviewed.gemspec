# -*- encoding: utf-8 -*-
require File.expand_path('../lib/reviewed/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Nick Plante", "Kevin Incorvia"]
  gem.email         = ["development@reviewed.com"]
  gem.description   = %q{Client library for the Reviewed.com API}
  gem.summary       = %q{A Ruby Gem for Accessing the Reviewed.com API}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "reviewed"
  gem.require_paths = ["lib"]
  gem.version       = Reviewed::VERSION

  gem.add_dependency 'activesupport', '>= 3.0'
  gem.add_dependency 'activemodel', '>=3.0'
  gem.add_dependency 'faraday'
  gem.add_dependency 'faraday_middleware'
  gem.add_dependency 'hashie', '~> 1.2'
  gem.add_dependency 'rack'
  gem.add_dependency 'redis-activesupport'
  gem.add_dependency 'multi_json'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec', '>= 2.10'
  gem.add_development_dependency 'webmock', '>= 1.8'
  gem.add_development_dependency 'vcr', '>= 2.1'
  gem.add_development_dependency 'guard-rspec', '>= 1.0'
  gem.add_development_dependency 'pry'
end
