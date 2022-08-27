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
      def list(params: {}, per_page: nil, page: nil)
        Collection.from_response(response: get_request(url: 'content/pages',
                                                       params: params,
                                                       per_page: per_page,
                                                       page: page),
                                 object_type: Bigcommerce::V3::Page)
      end
    end
  end
end
