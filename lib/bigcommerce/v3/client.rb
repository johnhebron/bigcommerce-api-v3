# frozen_string_literal: true

module Bigcommerce
  module V3
    ##
    # HTTP client for interacting with the BigCommerce HTTP API
    ##
    class Client
      class ClientConfigError < Error; end

      attr_reader :config, :conn

      def initialize(store_hash: nil, access_token: nil, config: nil)
        if config.nil?
          validate_params(store_hash: store_hash, access_token: access_token)
          @config = Configuration.new(store_hash: store_hash, access_token: access_token)
        else
          @config = config
        end

        @conn = create_connection
      end

      def create_connection
        Faraday.new(url: @config.full_api_path) do |conn|
          conn.headers = @config.http_headers
          conn.request :json
          conn.response :json
          if @config.logger
            conn.response :logger do |logger|
              logger.filter(/(X-Auth-Token: )([^&]+)/, '\1[REMOVED]')
            end
          end
          # Adapter must be last
          if @config.adapter && @config.stubs
            conn.adapter @config.adapter.to_sym, @config.stubs
          elsif @config.adapter
            conn.adapter @config.adapter.to_sym
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

        response = @conn.send(verb.downcase.to_sym, url, params)
        case response.status
        when 200..399
          Collection.from_response(response: response, object_type: OpenStruct)
        else
          raise Error, "[HTTP #{response.status}] Request failed with message: #{response.body['title']}"
        end
      end

      def customers
        CustomersResource.new(client: self)
      end

      def pages
        PagesResource.new(client: self)
      end

      private

      def validate_params(store_hash:, access_token:)
        return unless store_hash.nil? || access_token.nil? || store_hash.empty? || access_token.empty?

        raise ClientConfigError, 'Valid Configuration object or store_hash/access_token required.'
      end
    end
  end
end
