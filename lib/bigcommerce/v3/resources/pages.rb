# frozen_string_literal: true

module Bigcommerce
  module V3
    ##
    # Pages Resource
    # ----
    # Desc:     Create and manage customers
    # URI:      /stores/{{STORE_HASH}}/v3/customers
    # Docs:     https://developer.bigcommerce.com/api-reference/c98cfd443b0a0-customers-v3
    ##
    class PagesResource < Resource
      def list
        Collection.from_response response: get_request(url: 'content/pages'),
                                 object_type: Bigcommerce::V3::Page
      end
    end
  end
end
