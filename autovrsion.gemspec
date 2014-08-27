# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'autovrsion/version'

Gem::Specification.new do |spec|
  spec.name          = "autovrsion"
  spec.version       = Autovrsion::VERSION
  spec.authors       = ["Shaunak Pagnis"]
  spec.email         = ["shaunak.pagnis@gmail.com"]
  spec.summary       = %q{Command line tool for automatic versioning of files in a repository}
  spec.description   = %q{A command line tool that uses Rugged and Listen for automatic versioning of files.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.bindir        = 'bin'
  spec.executables   = 'autovrsion'
  #spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "ruby-git", "~> 0.2.2"
  spec.add_runtime_dependency "rugged" , "~> 0.21.0"
  spec.add_runtime_dependency "git" , "~> 1.2.6"
  spec.add_runtime_dependency "listen" , "~> 2.7.5"
  spec.add_runtime_dependency "colored", "~> 1.2"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
