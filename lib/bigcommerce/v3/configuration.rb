# frozen_string_literal: true

module Bigcommerce
  module V3
    ##
    # Configuration object which contains the necessary information
    # for an HTTP client to connect to the BigCommerce v3 HTTP API
    ##
    class Configuration
      BASE_API_PATH = 'https://api.bigcommerce.com/stores/'
      V3_API_PATH = 'v3/'

      attr_reader :store_hash, :access_token, :logger, :adapter, :stubs,
                  :full_api_path, :http_headers

      def initialize(store_hash:, access_token:, logger: nil, adapter: nil, stubs: nil)
        @store_hash = store_hash
        @access_token = access_token
        @logger = logger
        @adapter = adapter || Faraday.default_adapter
        @stubs = stubs

        validate_params

        @full_api_path = create_full_api_path
        @http_headers = create_http_headers
      end

      def create_full_api_path
        "#{BASE_API_PATH}#{@store_hash}/#{V3_API_PATH}"
      end

      def create_http_headers
        {
          'Content-Type' => 'application/json',
          'Accept' => 'application/json',
          'X-Auth-Token' => @access_token
        }
      end

      private

      def validate_params
        return unless @store_hash.nil? || @access_token.nil? || @store_hash.empty? || @access_token.empty?

        raise Error::ConfigurationError, 'Store_hash and access_token are required.'
      end
    end
  end
end
