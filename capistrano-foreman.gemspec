# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'capistrano-foreman'
  spec.version       = '0.0.1'
  spec.authors       = ['Koen Punt']
  spec.email         = ['me@koen.pt']
  spec.description   = %q{Foreman and upstart tasks for Capistrano 3.x}
  spec.summary       = %q{Foreman and upstart tasks for Capistrano 3.x}
  spec.homepage      = 'https://github.com/koenpunt/capistrano-foreman'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'capistrano', '~> 3.1'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
