# frozen_string_literal: true

require_relative 'lib/bigcommerce/v3/version'

Gem::Specification.new do |spec|
  spec.name = 'bigcommerce-v3'
  spec.version = Bigcommerce::V3::VERSION
  spec.authors = ['johnhebron']
  spec.email = ['johnhebron@gmail.com']

  spec.summary = 'Ruby Gem for working with the BigCommerce REST API V3.'
  spec.description = 'For more information about the BigCommerce REST API V3, please see https://developer.bigcommerce.com/docs/97b76565d4269-big-commerce-ap-is-quick-start#rest-api'
  spec.homepage = ''
  spec.license = 'MIT'
  spec.required_ruby_version = ['>= 3.0', '< 3.3']

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  # spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/johnhebron/bigcommerce-api-v3'
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '~> 2.5.2'
  spec.add_dependency 'rake', '~> 13.0'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata['rubygems_mfa_required'] = 'true'
end
