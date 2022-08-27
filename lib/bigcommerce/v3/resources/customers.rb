# frozen_string_literal: true

module Bigcommerce
  module V3
    ##
    # Customers Resource
    # ----
    # Desc:     Create and manage customers
    # URI:      /stores/{{STORE_HASH}}/v3/customers
    # Docs:     https://developer.bigcommerce.com/api-reference/c98cfd443b0a0-customers-v3
    ##
    class CustomersResource < Resource
      def list
        Collection.from_response response: get_request(url: 'customers'),
                                 object_type: Bigcommerce::V3::Customer
      end
    end
  end
end
