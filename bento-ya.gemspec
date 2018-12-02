$LOAD_PATH.unshift File.expand_path("lib", __dir__)
require "bento/version"

Gem::Specification.new do |gem|
  gem.name          = "bento-ya"
  gem.version       = Bento::VERSION
  gem.license       = "Apache-2.0"
  gem.authors       = ["Seth Thomas"]
  gem.email         = ["sthomas@chef.io"]
  gem.description   = "bento-ya builds bento boxes"
  gem.summary       = "A RubyGem for managing chef/bento builds"
  gem.homepage      = "https://github.com/chef/bento-ya"

  gem.files         = %w{LICENSE} + Dir.glob("{templates,bin,lib}/**/*")
  gem.bindir        = "bin"
  gem.executables   = %w{bento}
  gem.require_paths = ["lib"]

  gem.required_ruby_version = ">= 2.3.1"

  gem.add_dependency "mixlib-shellout", ">= 2.3.2"
  gem.add_dependency "vagrant_cloud", "~> 1.0"
end
