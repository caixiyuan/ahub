# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ahub/version'

Gem::Specification.new do |spec|
  spec.name          = "ahub"
  spec.version       = Ahub::VERSION
  spec.authors       = ["Abel Martin"]
  spec.email         = ["abel.martin@gmail.com"]

  spec.summary       = "A gem to interact with the Answer Hub API"
  spec.description   = "Answer Hub is a great product.  This gem allows you to easily interact with its API"
  spec.homepage      = "https://github.com/abelmartin/ahub"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  # spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.executables   << 'ahub'
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rest-client", "~> 1.7.3"
  spec.add_runtime_dependency "dotenv", "~> 2.0"
  spec.add_runtime_dependency "activesupport", "~> 4.2"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.3"
  spec.add_development_dependency "ffaker", "~> 1.24"
  spec.add_development_dependency "pry-byebug", "~> 3.2"
end
