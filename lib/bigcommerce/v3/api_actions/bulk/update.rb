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
            unless id.is_a?(Integer)
              raise Bigcommerce::V3::Error::InvalidArguments,
                    params_error(param: id, type: 'Integer')
            end
            unless params.is_a?(Hash)
              raise Bigcommerce::V3::Error::InvalidArguments,
                    params_error(param: params, type: 'Hash')
            end

            params[:id] = id
            bulk_update(params: [params])
          end
        end
      end
    end
  end
end
