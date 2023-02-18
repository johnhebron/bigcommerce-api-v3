# frozen_string_literal: true

module Bigcommerce
  module V3
    module APIActions
      ##
      # Available params for 'retrieve'
      # https://developer.bigcommerce.com/api-reference/
      ##
      module Retrieve
        ##
        # Retrieve Resource
        ##
        def retrieve(id:)
          url = "#{@resource_url}/#{id}"
          object_type = @object_type
          Bigcommerce::V3::Response.from_response(response: get_request(url: url),
                                                  object_type: object_type)
        end
      end
    end
  end
end
