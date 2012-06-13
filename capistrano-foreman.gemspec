# -*- encoding: utf-8 -*-
require File.expand_path('../lib/capistrano-foreman/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Johannes Gorset"]
  gem.email         = ["jgorset@gmail.com"]
  gem.description   = "Capistrano tasks for foreman and upstart."
  gem.summary       = "Capistrano tasks for foreman and upstart."
  gem.homepage      = "http://github.com/hyperoslo/capistrano-foreman"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "capistrano-foreman"
  gem.require_paths = ["lib"]
  gem.version       = Capistrano::Foreman::VERSION
end
