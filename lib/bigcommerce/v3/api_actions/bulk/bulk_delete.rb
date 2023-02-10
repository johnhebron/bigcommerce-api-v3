# frozen_string_literal: true

module Bigcommerce
  module V3
    module APIActions
      module Bulk
        ##
        # Available query parameters for 'bulk_delete'
        # https://developer.bigcommerce.com/api-reference/
        ##
        module BulkDelete
          def bulk_delete(ids:)
            unless ids.is_a?(Array)
              raise Bigcommerce::V3::Error::InvalidArguments,
                    params_error(param: ids, type: 'Array')
            end

            ids.map do |id|
              unless id.is_a?(Integer)
                raise Bigcommerce::V3::Error::InvalidArguments,
                      params_error(param: id, type: 'Array of Integers')
              end
            end

            url = @resource_url
            object_type = @object_type
            params = { 'id:in' => ids.join(',') }
            Bigcommerce::V3::Response.from_response(response: delete_request(url: url, params: params),
                                                    object_type: object_type)
          end
        end
      end
    end
  end
end
