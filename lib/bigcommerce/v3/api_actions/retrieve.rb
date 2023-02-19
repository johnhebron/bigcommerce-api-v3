# frozen_string_literal: true

module Bigcommerce
  module V3
    module APIActions
      ##
      # Available params for 'retrieve'
      # https://developer.bigcommerce.com/api-reference/
      ##
      module Retrieve
        ##
        # Retrieve Resource
        ##
        def retrieve(id:, params: {})
          raise_params_error(param: id, type: 'Integer') unless id.is_a?(Integer) && id >= 1
          raise_params_error(param: params, type: 'Hash') unless params.is_a?(Hash)

          url = retrieve_url(id)
          object_type = @object_type
          Bigcommerce::V3::Response.from_response(response: get_request(url: url, params: params),
                                                  object_type: object_type)
        end
      end
    end
  end
end
