# frozen_string_literal: true

module Bigcommerce
  module V3
    module APIActions
      module Bulk
        ##
        # Available params for 'create'
        # https://developer.bigcommerce.com/api-reference/
        ##
        module BulkCreate
          def bulk_create(params:)
            url = @resource_url
            object_type = @object_type

            case params
            when Array
              Bigcommerce::V3::Response.from_response(response: post_request(url: url, body: params),
                                                      object_type: object_type)
            when Hash
              Bigcommerce::V3::Response.from_response(response: post_request(url: url, body: [params]),
                                                      object_type: object_type)
            else
              raise_params_error(param: params, type: 'Hash or Array')
            end
          end
        end
      end
    end
  end
end
