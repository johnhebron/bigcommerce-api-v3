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

      attr_reader :client, :resource_url, :object_type

      def initialize(client:, resource_url:, object_type:)
        @client = client
        @resource_url = resource_url
        @object_type = object_type
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

      private

      def params_error(param:, type:)
        "Param(s) must be of type #{type}, #{param.class} provided."
      end
    end
  end
end
