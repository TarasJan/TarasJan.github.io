# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "jantar-theme"
  spec.version       = "0.2.0"
  spec.authors       = ["jan.taras29@gmail.com"]
  spec.email         = ["jan.taras29@gmail.com"]

  spec.summary       = "Custom theme for my personal website."
  spec.homepage      = "https://tarasjan.github.io"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").select { |f| f.match(%r!^(assets|_layouts|_includes|_sass|LICENSE|README)!i) }

  spec.add_runtime_dependency "jekyll", "~> 3.8"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 12.0"
end
