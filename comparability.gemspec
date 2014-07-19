# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'comparability/version'

Gem::Specification.new do |spec|
  spec.name          = 'comparability'
  spec.version       = Comparability::VERSION
  spec.authors       = ['Ippei Ukai']
  spec.email         = ['ippei@users.sourceforge.net']
  spec.summary       = 'Provides Comparator and declarative definition of comparison operator.'
  spec.homepage      = 'http://github.com/ippeiukai/comparability'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split('\x0')
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
end
