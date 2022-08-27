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

      attr_reader :store_hash, :access_token,
                  :full_api_path, :http_headers

      def initialize(store_hash:, access_token:)
        @store_hash = store_hash
        @access_token = access_token

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

      def validate_params
        return unless @store_hash.nil? || @access_token.nil? || @store_hash.empty? || @access_token.empty?

        raise ::Bigcommerce::V3::Error, 'Store_hash and access_token are required'
      end
    end
  end
end
