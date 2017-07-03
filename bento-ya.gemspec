# -*- encoding: utf-8 -*-
$:.unshift File.expand_path("../lib", __FILE__)
require "bento/version"
require "English"

Gem::Specification.new do |gem|
  gem.name          = "bento-ya"
  gem.version       = Bento::VERSION
  gem.license       = "Apache-2.0"
  gem.authors       = ["Seth Thomas"]
  gem.email         = ["sthomas@chef.io"]
  gem.description   = "bento-ya builds bento boxes"
  gem.summary       = "A RubyGem for managing chef/bento builds"
  gem.homepage      = "https://github.com/cheeseplus/bento-ya"

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.bindir = "bin"
  gem.executables   = %w[bento]
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.required_ruby_version = ">= 2.3.1"

  gem.add_dependency 'rake', '~> 11.2'
  gem.add_dependency 'mixlib-shellout', '~> 2.2'
  gem.add_dependency 'buildkit', '~> 0.4'
end
