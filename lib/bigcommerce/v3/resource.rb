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
        merged_params = merge_params(params: params, per_page: per_page, page: page)
        client.conn.get(url, merged_params, headers)
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

      private

      def merge_params(params: {}, per_page: nil, page: nil)
        params[:limit] = per_page.to_s unless per_page.nil?
        params[:page] = page.to_s unless page.nil?
        params
      end
    end
  end
end
