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

      ##
      # Convenience method to pass a single id
      # since the list endpoint supports bulk by default
      ##
      def retrieve(id:)
        list(params: { 'id:in' => id })
      end

      ##
      # Available params for 'create'
      # https://developer.bigcommerce.com/api-reference/726d081517f41-create-pages
      ##
      def bulk_create(params:)
        url = RESOURCE_URL

        case params
        when Array
          Bigcommerce::V3::Response.from_response(response: post_request(url: url, body: params),
                                                  object_type: Bigcommerce::V3::Customer)
        when Hash
          Bigcommerce::V3::Response.from_response(response: post_request(url: url, body: [params]),
                                                  object_type: Bigcommerce::V3::Customer)
        else
          raise Error::InvalidArguments, params_error(param: params, type: 'Hash or Array')
        end
      end

      ##
      # Convenience method to pass a single hash instead of an array of hashes
      # since the create endpoint supports bulk by default
      ##
      def create(params:)
        raise Error::ParamError, params_error(param: params, type: 'Hash') unless params.is_a?(Hash)

        bulk_create(params: [params])
      end

      ##
      # Available params for 'update'
      # https://developer.bigcommerce.com/api-reference/649c64eea69de-update-pages
      ##
      def bulk_update(params:)
        raise Error::ParamError, params_error(param: params, type: 'Array') unless params.is_a?(Array)

        url = RESOURCE_URL
        Bigcommerce::V3::Response.from_response(response: put_request(url: url, body: params),
                                                object_type: Bigcommerce::V3::Page)
      end

      ##
      # Convenience method to pass a single id and params
      # since the update endpoint supports bulk by default
      ##
      def update(id:, params:)
        raise Error::InvalidArguments, params_error(param: id, type: 'Integer') unless id.is_a?(Integer)
        raise Error::InvalidArguments, params_error(param: params, type: 'Hash') unless params.is_a?(Hash)

        params[:id] = id
        bulk_update(params: [params])
      end

      ##
      # Available query parameters for 'bulk_delete'
      # https://developer.bigcommerce.com/api-reference/d74089ee212a2-delete-pages#Query-Parameters
      ##
      def bulk_delete(ids:)
        raise Error::InvalidArguments, params_error(param: ids, type: 'Array') unless ids.is_a?(Array)

        ids.map do |id|
          raise Error::InvalidArguments, params_error(param: id, type: 'Array of Integers') unless id.is_a?(Integer)
        end

        url = RESOURCE_URL
        params = { 'id:in' => ids.join(',') }
        Bigcommerce::V3::Response.from_response(response: delete_request(url: url, params: params),
                                                object_type: Bigcommerce::V3::Page)
      end

      ##
      # Convenience method to pass a single id
      # since the delete endpoint supports bulk by default
      ##
      def delete(id:)
        raise Error::InvalidArguments, params_error(param: id, type: 'Integer') unless id.is_a?(Integer)

        bulk_delete(ids: [id])
      end
    end
  end
end
