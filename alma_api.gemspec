require_relative 'lib/alma_api/version'

Gem::Specification.new do |spec|
  spec.name          = "alma_api"
  spec.version       = AlmaApi::VERSION
  spec.authors       = ["Jon Gorman"]
  spec.email         = ["jtgorman@illinois.edu"]

  spec.summary       = %q{Acts a wrapper around Alma's api and handles threshold exceeded errors as well as tries to apply reasonable threshold limits to calls.}
#  spec.description   = %q{TODO: Write a longer description or delete this line.}

  spec.homepage      = "https://github.com/UIUCLibrary/alma-api-batch"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/UIUCLibrary/alma-api-batch"
  #TODO: Replace with changelog when exists
  spec.metadata["changelog_uri"] = "https://github.com/UIUCLibrary/alma-api-batch/blob/master/LICENSEhttps://github.com/UIUCLibrary/alma-api-batch/blob/master/changelog.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_runtime_dependency 'ruby-limiter'
  spec.add_runtime_dependency "nokogiri"
  spec.add_runtime_dependency "addressable"

end
