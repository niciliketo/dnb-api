# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name                  = 'dnb-api'
  s.version               = '0.0.0'
  s.date                  = '2021-01-24'
  s.summary               = 'Ruby wrapper to the D&B API'
  s.description           = 'Ruby wrapper to the D&B Connect Plus API'
  s.authors               = ['Nic Martin']
  s.email                 = 'nicholas.martin@marketdojo.com'
  s.required_ruby_version = '~> 2.0'
  s.files                 = %w[README.md Rakefile dnb-api.gemspec]
  s.files += Dir.glob('lib/**/*.rb')
  s.files += Dir.glob('dummy_responses/*.json')
  s.add_runtime_dependency 'faraday', '~> 0.1'
  s.add_development_dependency 'vcr', '~> 6'
  s.homepage              = 'https://github.com/marketdojo/dnb-api'
  s.license               = 'MIT'
end