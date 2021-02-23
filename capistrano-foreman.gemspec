# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.authors       = ["Johannes Gorset", 'John Bellone']
  gem.email         = ["jgorset@gmail.com", 'jbellone@bloomberg.net']
  gem.description   = "Capistrano tasks for foreman and upstart/systemd."
  gem.summary       = "Capistrano tasks for foreman and upstart/systemd."
  gem.homepage      = "http://github.com/hyperoslo/capistrano-foreman"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "capistrano-foreman"
  gem.require_paths = ["lib"]
  gem.version       = '1.4.0'

  gem.add_dependency 'capistrano', '~> 3.1'
end
