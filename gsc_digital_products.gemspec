# frozen_string_literal: true

require_relative "lib/gsc_digital_products/version"

Gem::Specification.new do |spec|
  spec.name = "gsc_digital_products"
  spec.version = GscDigitalProducts::VERSION
  spec.authors = ["Inkblot Technologies"]

  spec.summary = "Ruby client for interacting with the Green Shield Canada Digital Products API"
  spec.homepage = "https://github.com/inkblot-therapy/gsc-digital-products"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.pkg.github.com/inkblot-therapy"

  spec.metadata["homepage_uri"] = "https://github.com/inkblot-therapy/gsc-digital-products"
  spec.metadata["source_code_uri"] = "https://github.com/inkblot-therapy/gsc-digital-products"
  spec.metadata["github_repo"] = "ssh://github.com/inkblot-therapy/gsc-digital-products"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 2.12.0"

  spec.add_development_dependency "rspec", "~> 3"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
