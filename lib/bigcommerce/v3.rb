# frozen_string_literal: true

require "faraday"

require "bigcommerce/v3/version"

module Bigcommerce
  module V3
    autoload :Configuration, "bigcommerce/v3/configuration"
    autoload :Client, "bigcommerce/v3/client"
    autoload :Error, "bigcommerce/v3/error"
  end
end
