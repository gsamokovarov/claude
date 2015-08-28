# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'claude/version'

Gem::Specification.new do |spec|
  spec.name          = "claude"
  spec.version       = Claude::VERSION
  spec.authors       = ["Genadi Samokovarov"]
  spec.email         = ["gsamokovarov@gmail.com"]

  spec.summary       = "Claude transparently encrypts and decrypts sensitive Active Record attributes."
  spec.description   = "Claude transparently encrypts and decrypts sensitive Active Record attributes."
  spec.homepage      = "https://github.com/gsamokovarov/claude"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  rails_version = ">= 3.2"

  spec.add_dependency "railties",     rails_version
  spec.add_dependency "activerecord", rails_version

  spec.add_development_dependency "rails", rails_version
end
