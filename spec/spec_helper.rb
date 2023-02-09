# frozen_string_literal: true

require 'simplecov'
require 'support/helpers'
require 'support/shared_contexts'
require 'support/shared_examples'
require 'rspec'
require 'securerandom'
require 'bigcommerce/v3'

SimpleCov.start

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  # Add ability to use "describe" instead of "RSpec.describe"
  config.expose_dsl_globally = true

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include Helpers
end
