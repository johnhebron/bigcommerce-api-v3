# frozen_string_literal: true

module Bigcommerce
  module V3
    ##
    # Category Trees Resource
    # ----
    # Desc:     Category Trees
    # URI:      /stores/{{STORE_HASH}}/v3/catalog/trees
    # Docs:
    ##
    class CategoryTreesResource < Resource
      include Bigcommerce::V3::APIActions::List
      include Bigcommerce::V3::APIActions::Retrieve

      RESOURCE_URL = 'catalog/trees'
      OBJECT_TYPE = Bigcommerce::V3::CategoryTree

      def initialize(client:)
        super(client: client,
              resource_url: RESOURCE_URL,
              object_type: OBJECT_TYPE)
      end

      def url_for_retrieve(id:)
        "#{RESOURCE_URL}/#{id}/categories"
      end

      ##
      # Update Resource
      ##
      def update(id:, params:)
        raise_params_error(param: id, type: 'Integer or Nil') unless id.is_a?(Integer) || id.nil?
        raise_params_error(param: params, type: 'Array') unless params.is_a?(Array)

        params = update_params(id: id, params: params)
        url = RESOURCE_URL
        Bigcommerce::V3::Response.from_response(response: put_request(url: url, body: params),
                                                object_type: OBJECT_TYPE)
      end

      def update_params(id:, params:)
        params.first[:id] = id.to_i if id
        params
      end

      ##
      # Delete Resource
      ##
      def delete(id:)
        raise_params_error(param: id, type: 'Integer') unless id.is_a?(Integer)

        params = { 'id:in' => id }
        url = RESOURCE_URL
        Bigcommerce::V3::Response.from_response(response: delete_request(url: url, params: params),
                                                object_type: OBJECT_TYPE)
      end
    end
  end
end
