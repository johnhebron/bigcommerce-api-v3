# frozen_string_literal: true

module Bigcommerce
  module V3
    ##
    # Abandoned Cart Emails Resource
    # ----
    # Desc:     Abandoned Cart Emails V3 API managing Handlebars-based emails.
    # URI:      /stores/{{STORE_HASH}}/v3/marketing/abandoned-cart-emails
    # Docs:
    ##
    class AbandonedCartEmailsResource < Resource
      include Bigcommerce::V3::APIActions::List
      include Bigcommerce::V3::APIActions::Retrieve

      RESOURCE_URL = 'marketing/abandoned-cart-emails'
      OBJECT_TYPE = Bigcommerce::V3::AbandonedCartEmail

      def initialize(client:)
        super(client: client,
              resource_url: RESOURCE_URL,
              object_type: OBJECT_TYPE)
      end

      ##
      # Create Resource
      ##
      def create(params:)
        raise_params_error(param: params, type: 'Hash') unless params.is_a?(Hash)

        url = RESOURCE_URL
        Bigcommerce::V3::Response.from_response(response: post_request(url: url,
                                                                       body: params),
                                                object_type: OBJECT_TYPE)
      end

      ##
      # Update Resource
      ##
      def update(id:, params:)
        raise_params_error(param: id, type: 'Integer') unless id.is_a?(Integer)
        raise_params_error(param: params, type: 'Hash') unless params.is_a?(Hash)

        url = "#{RESOURCE_URL}/#{id}"
        Bigcommerce::V3::Response.from_response(response: put_request(url: url, body: params),
                                                object_type: OBJECT_TYPE)
      end

      ##
      # Delete Resource
      ##
      def delete(id:)
        raise_params_error(param: id, type: 'Integer') unless id.is_a?(Integer)

        url = "#{RESOURCE_URL}/#{id}"
        Bigcommerce::V3::Response.from_response(response: delete_request(url: url),
                                                object_type: OBJECT_TYPE)
      end

      ##
      # Get Default Template
      ##
      def default
        url = "#{RESOURCE_URL}/default"
        Bigcommerce::V3::Response.from_response(response: get_request(url: url),
                                                object_type: OBJECT_TYPE)
      end
    end
  end
end
