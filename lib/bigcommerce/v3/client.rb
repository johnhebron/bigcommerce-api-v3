# frozen_string_literal: true

module Bigcommerce
  module V3
    class Client
      attr_reader :config, :conn

      def initialize(store_hash: '', access_token: '', config: nil)
        if config.nil?
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
    end
  end
end
