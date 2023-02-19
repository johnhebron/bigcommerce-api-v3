# frozen_string_literal: true

module Bigcommerce
  module V3
    module APIActions
      ##
      # Available params for 'list'
      # https://developer.bigcommerce.com/api-reference/
      ##
      module Update
        def update(id:, params:)
          raise_params_error(param: id, type: 'Integer') unless id.is_a?(Integer)
          raise_params_error(param: params, type: 'Hash') unless params.is_a?(Hash)

          url = update_url(id: id)
          params = update_params(params: params)
          object_type = @object_type
          Bigcommerce::V3::Response.from_response(response: put_request(url: url, body: params),
                                                  object_type: object_type)
        end

        def update_params(params:)
          params
        end
      end
    end
  end
end
