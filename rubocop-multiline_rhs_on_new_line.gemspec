require_relative "lib/rubocop/multiline_rhs_on_new_line/version"

Gem::Specification.new do |spec|
  spec.name = "rubocop-multiline_rhs_on_new_line"
  spec.version = RuboCop::MultilineRhsOnNewLine::VERSION
  spec.authors = ["s4na"]
  spec.email = []

  spec.summary = "RuboCop cop that enforces multiline RHS to start on a new line"
  spec.description = <<~DESC
    A RuboCop extension that enforces the right-hand side of an assignment
    to begin on a new line when it spans multiple lines.
  DESC
  spec.homepage = "https://github.com/s4na/rubocop-multiline_rhs_on_new_line"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir[
    "lib/**/*",
    "README.md",
    "CHANGELOG.md",
    "LICENSE.txt"
  ]
  spec.require_paths = ["lib"]

  spec.add_dependency "rubocop", ">= 1.50"
end
