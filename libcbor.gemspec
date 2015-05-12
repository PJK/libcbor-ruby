# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'libcbor/version'

Gem::Specification.new do |spec|
  spec.name          = "libcbor"
  spec.version       = CBOR::VERSION
  spec.authors       = ["Pavel Kalvoda"]
  spec.email         = ["me@pavelkalvoda.com"]

  spec.summary       = %q{A Ruby binding for libcbor}
  spec.description   = %q{CBOR (Concise Binary Object Representation) implementation based on the libcbor C library. Provides all the encoding and decoding facilities of libcbor, including the streaming interface}
  spec.homepage      = "https://github.com/PJK/libcbor-ruby"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]


  spec.add_development_dependency "bundler", "> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "> 3"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "yard"
  spec.add_development_dependency "redcarpet"
  spec.add_development_dependency "coveralls"

  spec.add_runtime_dependency "ffi"
end
