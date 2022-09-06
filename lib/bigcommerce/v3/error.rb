# frozen_string_literal: true

module Bigcommerce
  module V3
    class Error < StandardError
      class ClientConfigError < Error; end
      class ConfigurationError < Error; end
      class HTTPError < Error; end
      class InvalidArguments < Error; end
      class PaginationDataMissing < Error; end
      class ParamError < Error; end
      class RecordNotFound < Error; end
    end
  end
end
