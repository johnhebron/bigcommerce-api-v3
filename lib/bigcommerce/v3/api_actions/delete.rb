# frozen_string_literal: true

module Bigcommerce
  module V3
    module APIActions
      ##
      # Available params for 'list'
      # https://developer.bigcommerce.com/api-reference/
      ##
      module Delete
        def delete(id:)
          raise_params_error(param: id, type: 'Integer') unless id.is_a?(Integer)

          url = "#{@resource_url}/#{id}"
          object_type = @object_type
          Bigcommerce::V3::Response.from_response(response: delete_request(url: url),
                                                  object_type: object_type)
        end
      end
    end
  end
end
