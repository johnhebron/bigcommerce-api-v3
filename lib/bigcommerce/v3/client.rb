# frozen_string_literal: true

module Bigcommerce
  module V3
    ##
    # HTTP client for interacting with the BigCommerce HTTP API
    ##
    class Client
      class ClientConfigError < Error; end

      attr_reader :config, :conn

      def initialize(store_hash: '', access_token: '', config: nil, logger: false)
        if config.nil?
          validate_params(store_hash: store_hash, access_token: access_token)
          @config = Configuration.new(store_hash: store_hash, access_token: access_token)
        else
          @config = config
        end

        @conn = create_connection(logger: logger)
      end

      def create_connection(logger:)
        Faraday.new(url: @config.full_api_path) do |conn|
          conn.headers = @config.http_headers
          conn.request :json
          conn.response :json
          if logger
            conn.response :logger do |logger|
              logger.filter(/(X-Auth-Token: )([^&]+)/, '\1[REMOVED]')
            end
          end
        end
      end

      def raw_request(verb:, url:, params: {}, per_page: nil, page: nil)
        params.merge!(
          {
            limit: per_page.nil? ? nil : per_page.to_s,
            page: page.nil? ? nil : page.to_s
          }.compact
        )

        Collection.from_response(response: @conn.send(verb.downcase.to_sym, url, params),
                                 object_type: OpenStruct)
      end

      def customers
        CustomersResource.new(client: self)
      end

      def pages
        PagesResource.new(client: self)
      end

      private

      def validate_params(store_hash:, access_token:)
        return unless store_hash.empty? || access_token.empty?

        raise ClientConfigError, 'Valid Configuration object or store_hash/access_token required'
      end
    end
  end
end
