require_relative 'lib/slack_on_deploy/version'

Gem::Specification.new do |spec|
  spec.name          = "slack_on_deploy"
  spec.version       = SlackOnDeploy::VERSION
  spec.authors       = ["Calvin Delamere"]
  spec.email         = ["elbartostrikesagain@gmail.com"]

  spec.summary       = %q{Sends slack notification for users based on text inputs}
  spec.description   = %q{Sends slack notification for users based on text inputs}
  spec.homepage      = "http://transviewlogistics.com"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.2.8")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  #spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  #spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'slack-notifier', '~> 2.3'
  spec.add_runtime_dependency 'redis'
end
