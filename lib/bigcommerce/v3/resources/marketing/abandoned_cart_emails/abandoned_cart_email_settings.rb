# frozen_string_literal: true

module Bigcommerce
  module V3
    ##
    # Abandoned Cart Email Settings Resource
    # ----
    # Desc:     Abandoned Cart Emails V3 API Settings
    # URI:      /stores/{{STORE_HASH}}/v3/marketing/abandoned-cart-emails/settings
    # Docs:
    ##
    class AbandonedCartEmailSettingsResource < Resource
      RESOURCE_URL = 'marketing/abandoned-cart-emails/settings'
      OBJECT_TYPE = Bigcommerce::V3::AbandonedCartEmailSettings

      def initialize(client:)
        super(client: client,
              resource_url: RESOURCE_URL,
              object_type: OBJECT_TYPE)
      end

      ##
      # Retrieve Resource
      ##
      def retrieve(id:)
        raise_params_error(param: id, type: 'Integer') unless id.is_a?(Integer)

        params = { channel_id: id }
        url = RESOURCE_URL
        Bigcommerce::V3::Response.from_response(response: get_request(url: url, params: params),
                                                object_type: OBJECT_TYPE)
      end

      ##
      # Update Resource
      ##
      def update(id:, params:)
        raise_params_error(param: id, type: 'Integer') unless id.is_a?(Integer)
        raise_params_error(param: params, type: 'Hash') unless params.is_a?(Hash)

        params[:channel_id] = id
        url = RESOURCE_URL
        Bigcommerce::V3::Response.from_response(response: put_request(url: url, body: params),
                                                object_type: OBJECT_TYPE)
      end
    end
  end
end
