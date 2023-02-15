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
            raise_params_error(param: params, type: 'Array') unless params.is_a?(Array)
            params.each do |param|
              raise Bigcommerce::V3::Error::InvalidArguments, ':params elements must be Hashes' unless param.is_a?(Hash)
            end
            raise Bigcommerce::V3::Error::InvalidArguments, ':params must not be empty' if params.empty?

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
