# frozen_string_literal: true

module Bigcommerce
  module V3
    class Client
      attr_reader :config, :conn

      def initialize(store_hash: '', access_token: '', config: nil)
        if config.nil?
          validate_params(store_hash: store_hash, access_token: access_token)
          @config = Configuration.new(store_hash: store_hash, access_token: access_token)
        else
          @config = config
        end

        @conn = create_connection
      end

      def create_connection
        Faraday.new(
          url: @config.full_api_path,
          headers: @config.http_headers
        )
      end

      def validate_params(store_hash: , access_token: )
        if (store_hash.empty? || access_token.empty?)
          raise ::Bigcommerce::V3::Error, 'Valid Configuration object or store_hash/access_token required'
        end
      end
    end
  end
end
