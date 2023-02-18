# frozen_string_literal: true

module Bigcommerce
  module V3
    module APIActions
      ##
      # Available params for 'list'
      # https://developer.bigcommerce.com/api-reference/
      ##
      module Create
        def create(params:)
          raise_params_error(param: params, type: 'Hash') unless params.is_a?(Hash)

          url = @resource_url
          object_type = @object_type
          Bigcommerce::V3::Response.from_response(response: post_request(url: url,
                                                                         body: params),
                                                  object_type: object_type)
        end
      end
    end
  end
end
