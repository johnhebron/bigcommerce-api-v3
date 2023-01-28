# frozen_string_literal: true

module Bigcommerce
  module V3
    ##
    # Pages Resource
    # ----
    # Desc:     Manage content pages, such as contact forms, rss feeds, and custom HTML pages
    # URI:      /stores/{{STORE_HASH}}/v3/content/pages
    # Docs:     https://developer.bigcommerce.com/api-reference/16c5ea267cfec-pages-v3
    ##
    class PagesResource < Resource
      RESOURCE_URL = 'content/pages'

      ##
      # Available query parameters for 'list'
      # https://developer.bigcommerce.com/api-reference/831028b2a1c70-get-pages#Query-Parameters
      ##
      def list(params: {}, per_page: nil, page: nil)
        url = RESOURCE_URL
        Bigcommerce::V3::Response.from_response(response: get_request(url: url,
                                                                      params: params,
                                                                      per_page: per_page,
                                                                      page: page),
                                                object_type: Bigcommerce::V3::Page)
      end

      def create(params:)
        raise Error::ParamError, "Params must be of type Hash, #{params.class} provided." unless params.is_a?(Hash)

        bulk_create(params: [params]).data.first
      end

      def bulk_create(params:)
        raise Error::ParamError, "Params must be of type Array, #{params.class} provided." unless params.is_a?(Array)

        url = RESOURCE_URL
        Bigcommerce::V3::Response.from_response(response: post_request(url: url, body: params),
                                                object_type: Bigcommerce::V3::Page)
      end

      def retrieve(page_id:)
        raise Error::ParamError, "Page_id must be an Integer, #{page_id.class} provided." unless page_id.is_a?(Integer)

        url = "#{RESOURCE_URL}/#{page_id}"
        Bigcommerce::V3::Page.new(get_request(url: url).body['data'])
      end

      def update(page_id:, params:)
        raise Error::ParamError, "Page_id must be an Integer, #{page_id.class} provided." unless page_id.is_a?(Integer)
        raise Error::ParamError, "Params must be of type Hash, #{params.class} provided." unless params.is_a?(Hash)

        url = "#{RESOURCE_URL}/#{page_id}"
        Bigcommerce::V3::Page.new(put_request(url: url, body: params).body['data'])
      end

      def bulk_update(params:)
        raise Error::ParamError, "Params must be of type Array, #{params.class} provided." unless params.is_a?(Array)

        url = RESOURCE_URL
        Bigcommerce::V3::Response.from_response(response: put_request(url: url, body: params),
                                                object_type: Bigcommerce::V3::Page)
      end

      def delete(page_id:)
        raise Error::ParamError, "Page_id must be an Integer, #{page_id.class} provided." unless page_id.is_a?(Integer)

        url = "#{RESOURCE_URL}/#{page_id}"
        delete_request(url: url)
        true
      end

      ##
      # Available query parameters for 'bulk_delete'
      # https://developer.bigcommerce.com/api-reference/d74089ee212a2-delete-pages#Query-Parameters
      ##
      def bulk_delete(page_ids:)
        raise Error::ParamError, "Params must be of type Array, #{page_ids.class} provided." unless page_ids.is_a?(Array)

        url = RESOURCE_URL
        params = { 'id:in' => page_ids.join(',') }
        delete_request(url: url, params: params)
        true
      end
    end
  end
end
