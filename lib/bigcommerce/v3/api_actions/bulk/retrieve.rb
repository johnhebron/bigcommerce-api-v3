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
          def retrieve(id:)
            raise_params_error(param: id, type: 'Integer') unless id.is_a?(Integer)
            if id < 1
              raise Bigcommerce::V3::Error::InvalidArguments,
                    ':id must be >= 0'
            end

            list(params: { 'id:in' => id })
          end
        end
      end
    end
  end
end
