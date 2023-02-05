# frozen_string_literal: true

module Bigcommerce
  module V3
    ##
    # Base entity for individual resource actions to inherit from
    ##
    class Resource
      DEFAULTS = {
        per_page: 50,
        page: 1
      }.freeze

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
        params[:limit] = DEFAULTS[:per_page] if params[:limit].nil?
        params[:page] = DEFAULTS[:page] if params[:page].nil?

        client.conn.get(url, params, headers)
      end

      def post_request(url:, body:, headers: {})
        client.conn.post(url, body, headers)
      end

      def put_request(url:, body:, headers: {})
        client.conn.put(url, body, headers)
      end

      def delete_request(url:, params: {}, headers: {})
        client.conn.delete(url, params, headers)
      end
    end
  end
end
