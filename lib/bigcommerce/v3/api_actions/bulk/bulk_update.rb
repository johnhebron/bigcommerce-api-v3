# frozen_string_literal: true

module Bigcommerce
  module V3
    module APIActions
      module Bulk
        ##
        # Available params for 'update'
        # https://developer.bigcommerce.com/api-reference/
        ##
        module BulkUpdate
          def bulk_update(params:)
            unless params.is_a?(Array)
              raise Bigcommerce::V3::Error::ParamError,
                    params_error(param: params, type: 'Array')
            end

            url = @resource_url
            object_type = @object_type
            Bigcommerce::V3::Response.from_response(response: put_request(url: url, body: params),
                                                    object_type: object_type)
          end
        end
      end
    end
  end
end
