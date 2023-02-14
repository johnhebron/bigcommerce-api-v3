# frozen_string_literal: true

module Bigcommerce
  module V3
    module APIActions
      module Bulk
        ##
        # Convenience method to pass a single hash instead of an array of hashes
        # since the create endpoint supports bulk by default
        ##
        module Create
          def create(params:)
            raise_params_error(param: params, type: 'Hash') unless params.is_a?(Hash)

            bulk_create(params: [params])
          end
        end
      end
    end
  end
end
