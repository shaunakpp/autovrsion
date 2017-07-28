# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'autovrsion/version'

Gem::Specification.new do |spec|
  spec.name          = 'autovrsion'
  spec.version       = Autovrsion::VERSION
  spec.authors       = ['Shaunak Pagnis']
  spec.email         = ['shaunak.pagnis@gmail.com']
  spec.summary       = 'Command line tool for automatic version control'
  spec.description   = 'Automatic version control using `rugged` and `listen`'
  spec.homepage      = 'http://shaunakpp.github.io/autovrsion/'
  spec.license       = 'MIT'
  spec.files         = `git ls-files lib bin autovrsion.gemspec`.split($INPUT_RECORD_SEPARATOR)
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'ruby-git'
  spec.add_runtime_dependency 'rugged'
  spec.add_runtime_dependency 'git'
  spec.add_runtime_dependency 'listen'
  spec.add_runtime_dependency 'colored'
  spec.add_runtime_dependency 'wdm', '=> 0.1.0' if Gem.win_platform?
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
