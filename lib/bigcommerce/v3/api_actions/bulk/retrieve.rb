# frozen_string_literal: true

module Bigcommerce
  module V3
    module APIActions
      module Bulk
        ##
        # Convenience method to pass a single id
        # since the list endpoint supports bulk by default
        ##
        module Retrieve
          def retrieve(id:, params: {})
            raise_params_error(param: params, type: 'Hash') unless params.is_a?(Hash)
            raise_params_error(param: id, type: 'Integer') unless id.is_a?(Integer)
            raise Bigcommerce::V3::Error::InvalidArguments, ':id must be > 0' if id < 1

            list(params: params.merge({ 'id:in' => id }))
          end
        end
      end
    end
  end
end
