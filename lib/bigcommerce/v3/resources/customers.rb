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
      RESOURCE_URL = 'customers'

      def list(params: {}, per_page: nil, page: nil)
        url = RESOURCE_URL
        Collection.from_response(response: get_request(url: url,
                                                       params: params,
                                                       per_page: per_page,
                                                       page: page),
                                 object_type: Bigcommerce::V3::Customer)
      end

      def create(params:)
        url = RESOURCE_URL
        Bigcommerce::V3::Customer.new(post_request(url: url, body: params).body['data'])
      end

      def retrieve(customer_id:)
        url = "#{RESOURCE_URL}/#{customer_id}"
        Bigcommerce::V3::Customer.new(get_request(url: url).body['data'])
      end

      def update(customer_id:, params:)
        url = "#{RESOURCE_URL}/#{customer_id}"
        Bigcommerce::V3::Customer.new(put_request(url: url, body: params).body['data'])
      end

      def delete(customer_id:)
        url = "#{RESOURCE_URL}/#{customer_id}"
        delete_request(url: url)
        true
      end
    end
  end
end
