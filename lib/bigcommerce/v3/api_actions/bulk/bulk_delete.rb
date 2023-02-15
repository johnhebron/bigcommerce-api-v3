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
            ids.each do |id|
              raise Bigcommerce::V3::Error::InvalidArguments, ':id elements must be Integers' unless id.is_a?(Integer)
            end
            raise Bigcommerce::V3::Error::InvalidArguments, ':ids must not be empty' if ids.empty?

            ids.map do |id|
              raise_params_error(param: id, type: 'Array of Integers') unless id.is_a?(Integer)
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
