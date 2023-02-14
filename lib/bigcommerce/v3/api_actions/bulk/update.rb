# frozen_string_literal: true

module Bigcommerce
  module V3
    module APIActions
      module Bulk
        ##
        # Convenience method to pass a single id and params
        # since the update endpoint supports bulk by default
        ##
        module Update
          def update(id:, params:)
            raise_params_error(param: id, type: 'Integer') unless id.is_a?(Integer)
            raise_params_error(param: params, type: 'Hash') unless params.is_a?(Hash)
            raise Bigcommerce::V3::Error::InvalidArguments, ':params must not be empty' if params.empty?

            params['id'] = id
            bulk_update(params: [params])
          end
        end
      end
    end
  end
end
