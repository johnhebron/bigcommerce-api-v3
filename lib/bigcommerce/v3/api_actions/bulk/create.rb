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
            raise Bigcommerce::V3::Error::InvalidArguments, ':params must not be empty' if params.empty?

            bulk_create(params: [params])
          end
        end
      end
    end
  end
end
