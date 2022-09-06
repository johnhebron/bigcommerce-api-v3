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
        Collection.from_response(response: get_request(url: url,
                                                       params: params,
                                                       per_page: per_page,
                                                       page: page),
                                 object_type: Bigcommerce::V3::Page)
      end

      def create(params:)
        url = RESOURCE_URL
        Bigcommerce::V3::Page.new(post_request(url: url, body: params).body['data'])
      end

      def retrieve(page_id:)
        url = "#{RESOURCE_URL}/#{page_id}"
        Bigcommerce::V3::Page.new(get_request(url: url).body['data'])
      end

      def update(page_id:, params:)
        url = "#{RESOURCE_URL}/#{page_id}"
        Bigcommerce::V3::Page.new(put_request(url: url, body: params).body['data'])
      end

      ##
      # Available query parameters for 'delete'
      # https://developer.bigcommerce.com/api-reference/d74089ee212a2-delete-pages#Query-Parameters
      ##
      def delete(page_id:)
        url = "#{RESOURCE_URL}/#{page_id}"
        delete_request(url: url)
        true
      end
    end
  end
end
