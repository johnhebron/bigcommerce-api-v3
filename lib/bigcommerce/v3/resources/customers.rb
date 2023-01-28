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
        Bigcommerce::V3::Response.from_response(response: get_request(url: url,
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
          Bigcommerce::V3::Response.from_response(response: post_request(url: url, body: params),
                                                  object_type: Bigcommerce::V3::Customer)
        when Hash
          Bigcommerce::V3::Customer.new(post_request(url: url, body: [params]).body['data'][0])
        else
          raise Error::InvalidArguments, "Parms must be an Hash or an Array of Hashes, #{params.class} provided."
        end
      end

      # Convenience method to pass a single customer_id
      # since the list endpoint supports bulk by default
      def retrieve(customer_id:)
        params = { 'id:in' => customer_id }
        customer = list(params: params).data.first

        return customer unless customer.nil?

        raise Error::RecordNotFound, "Customer with the 'id' of '#{customer_id}' not found."
      end

      # Convenience method to pass a single customer_id and params
      # since the update endpoint supports bulk by default
      def update(customer_id:, params:)
        if params.is_a?(Hash)
          params[:id] = customer_id
          params = [params]
        end
        bulk_update(params: params).data.first
      end

      def bulk_update(params:)
        url = RESOURCE_URL
        Bigcommerce::V3::Response.from_response(response: put_request(url: url, body: params),
                                                object_type: Bigcommerce::V3::Customer)
      end

      # Convenience method to pass a single customer id
      # since the delete endpoint supports bulk by default
      def delete(customer_id:)
        url = RESOURCE_URL
        params = { 'id:in' => customer_id }
        delete_request(url: url, params: params)
        true
      end

      ##
      # Available query parameters for 'delete'
      # https://developer.bigcommerce.com/api-reference/e6bb04315e2a7-delete-customers#Query-Parameters
      ##
      def bulk_delete(customer_ids:)
        raise Error::ParamError, "Params must be of type Array, #{customer_ids.class} provided." unless customer_ids.is_a?(Array)

        url = RESOURCE_URL
        params = { 'id:in' => customer_ids.join(',') }
        delete_request(url: url, params: params)
        true
      end
    end
  end
end
