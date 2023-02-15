# frozen_string_literal: true

module Bigcommerce
  module V3
    module APIActions
      module Bulk
        ##
        # Convenience method to pass a single id
        # since the delete endpoint supports bulk by default
        ##
        module Delete
          def delete(id:)
            raise_params_error(param: id, type: 'Integer') unless id.is_a?(Integer)
            raise Bigcommerce::V3::Error::InvalidArguments, ':id must be > 0' if id < 1

            bulk_delete(ids: [id])
          end
        end
      end
    end
  end
end
