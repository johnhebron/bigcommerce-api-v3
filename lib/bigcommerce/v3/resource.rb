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
        check_url(url: url)
        check_params(params: params, per_page: per_page, page: page)
        check_headers(headers: headers)

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
        check_url(url: url)
        check_body(body: body)
        check_headers(headers: headers)

        client.conn.post(url, body, headers)
      end

      def put_request(url:, body:, headers: {})
        check_url(url: url)
        check_body(body: body)
        check_headers(headers: headers)

        client.conn.put(url, body, headers)
      end

      def delete_request(url:, params: {}, headers: {})
        check_url(url: url)
        check_params(params: params)
        check_headers(headers: headers)

        client.conn.delete(url, params, headers)
      end

      private

      def raise_params_error(param:, type:)
        raise Bigcommerce::V3::Error::InvalidArguments,
              "'#{type}' required, #{param.class} provided."
      end

      def check_url(url:)
        raise_params_error(param: url, type: 'String') unless url.is_a?(String)
      end

      def check_headers(headers:)
        raise_params_error(param: headers, type: 'Hash') unless headers.is_a?(Hash)
      end

      def check_body(body:)
        raise_params_error(param: body, type: 'Hash') if body.nil?
      end

      def check_params(params: nil, per_page: nil, page: nil)
        if !params.is_a?(Array) && @object_type == Bigcommerce::V3::CategoryTreesResource
          raise_params_error(param: params, type: 'Array')
        elsif !params.is_a?(Hash)
          raise_params_error(param: params, type: 'Hash')
        end
        raise_params_error(param: per_page, type: 'Integer') if per_page && !per_page.is_a?(Integer)
        raise_params_error(param: page, type: 'Integer') if page && !page.is_a?(Integer)
      end
    end
  end
end
