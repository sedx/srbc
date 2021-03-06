# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'srbc/version'

Gem::Specification.new do |spec|
  spec.name          = "srbc"
  spec.version       = SrbcVersion::VERSION
  spec.authors       = ["Ilya Bondarenko"]
  spec.email         = ["bondarenko.ik@gmail.com"]
  spec.summary       = %q{SRBC extend windows comand line. Provide easy way to run ruby scripts}
  spec.description   = %q{Start ruby Console with extend features. Let execute ruby files without type "ruby" and "rb" extention.For exmple: type "main" to execute "runy main.rb". Also you can add custom executor: cucumber, python, ping or what you want.}
  spec.homepage      = "https://github.com/sedx/srbc"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.executables << 'srbc'
end
