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
            list(params: { 'id:in' => id })
          end
        end
      end
    end
  end
end
