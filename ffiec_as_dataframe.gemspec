# frozen_string_literal: true

require_relative "lib/ffiec_as_dataframe/version"

Gem::Specification.new do |spec|
  spec.name = "ffiec_as_dataframe"
  spec.version = FfiecAsDataframe::VERSION
  spec.authors = ["Bill McKinnon"]
  spec.email = ["bill.mckinnon@bmck.org"]

  spec.summary       = "Call report data from FFIEC"
  spec.description   = "Call report data from FFIEC"
  spec.homepage      = "https://github.com/bmck/ffiec_as_dataframe"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 3.3")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/bmck/ffiec_as_dataframe"
  spec.metadata["changelog_uri"] = "https://github.com/bmck/ffiec_as_dataframe/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency 'csv', '~> 3.3'
  spec.add_dependency 'polars-df', '0.27.1'
  spec.add_dependency 'rubyzip', '~> 3.7'
  spec.add_dependency 'activesupport', '~> 8.1'
  spec.add_dependency 'selenium-webdriver', '~> 4.54'

  spec.add_development_dependency 'minitest', '~> 6.1'
  spec.add_development_dependency 'minitest-mock', '~> 5.27'
  spec.add_development_dependency 'rake', '~> 13.0'
end
