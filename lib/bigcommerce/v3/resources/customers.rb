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

      ##
      # Available query parameters for 'list'
      # https://developer.bigcommerce.com/api-reference/761ec193054b6-get-all-customers#Query-Parameters
      ##
      def list(params: {}, per_page: nil, page: nil)
        url = RESOURCE_URL
        Collection.from_response(response: get_request(url: url,
                                                       params: params,
                                                       per_page: per_page,
                                                       page: page),
                                 object_type: Bigcommerce::V3::Customer)
      end

      # Convenience method to pass a single hash instead of an array of hashes
      # since the create endpoint supports bulk by default
      def create(params:)
        bulk_create(params: params)
      end

      def bulk_create(params:)
        url = RESOURCE_URL

        case params
        when Array
          Bigcommerce::V3::Customer.new(post_request(url: url, body: params).body['data'])
        when Hash
          Bigcommerce::V3::Customer.new(post_request(url: url, body: [params]).body['data'][0])
        else
          raise Error::InvalidArguments, "Parms must be an Hash or an Array of Hashes, #{params.class} provided."
        end
      end

      def retrieve(customer_id:)
        params = { 'id:in' => customer_id }
        customer = list(params: params).data.first

        return customer unless customer.nil?

        raise Error::RecordNotFound, "Customer with the 'id' of '#{customer_id}' not found."
      end

      def update(customer_id:, params:)
        url = "#{RESOURCE_URL}/#{customer_id}"
        Bigcommerce::V3::Customer.new(put_request(url: url, body: params).body['data'])
      end

      ##
      # Available query parameters for 'delete'
      # https://developer.bigcommerce.com/api-reference/e6bb04315e2a7-delete-customers#Query-Parameters
      ##
      def delete(customer_id:)
        url = RESOURCE_URL
        params = { 'id:in' => customer_id }
        delete_request(url: url, params: params)
        true
      end
    end
  end
end
