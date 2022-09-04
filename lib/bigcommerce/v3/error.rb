# frozen_string_literal: true

module Bigcommerce
  module V3
    class Error < StandardError
      class ClientConfigError < Error; end
      class ConfigurationError < Error; end
      class HTTPError < Error; end
      class InvalidArguments < Error; end
    end
  end
end
