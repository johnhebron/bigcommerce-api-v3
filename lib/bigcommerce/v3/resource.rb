# frozen_string_literal: true

module Bigcommerce
  module V3
    ##
    # Base entity for individual resource actions to inherit from
    ##
    class Resource
      attr_reader :client

      def initialize(client:)
        @client = client
      end

      def get_request(url:, params: {}, per_page: nil, page: nil, headers: {})
        params.merge!(
          {
            limit: per_page.nil? ? nil : per_page.to_s,
            page: page.nil? ? nil : page.to_s
          }.compact
        )
        handle_response client.conn.get(url, params, headers)
      end

      def post_request(url:, body:, headers: {})
        handle_response client.conn.post(url, body, headers)
      end

      def put_request(url:, body:, headers: {})
        handle_response client.conn.put(url, body, headers)
      end

      def delete_request(url:, params: {}, headers: {})
        handle_response client.conn.delete(url, params, headers)
      end

      private

      def handle_response(response)
        case response.status
        when 400..599
          raise Error::HTTPError, "[HTTP #{response.status}] Request failed with message: #{response.body['title']}"
        else
          response
        end
      end
    end
  end
end
