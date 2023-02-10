# frozen_string_literal: true

module Bigcommerce
  module V3
    module APIActions
      module Bulk
        ##
        # Available params for 'list'
        # https://developer.bigcommerce.com/api-reference/
        ##
        module List
          def list(params: {}, per_page: nil, page: nil)
            url = @resource_url
            Bigcommerce::V3::Response.from_response(response: get_request(url: url,
                                                                          params: params,
                                                                          per_page: per_page,
                                                                          page: page),
                                                    object_type: object_type)
          end
        end
      end
    end
  end
end
