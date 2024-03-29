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
      include Bigcommerce::V3::APIActions::Retrieve

      RESOURCE_URL = 'marketing/abandoned-cart-emails/settings'
      OBJECT_TYPE = Bigcommerce::V3::AbandonedCartEmailSettings

      def initialize(client:)
        super(client: client,
              resource_url: RESOURCE_URL,
              object_type: OBJECT_TYPE)
      end

      def url_for_retrieve(id:)
        RESOURCE_URL
      end

      def params_for_retrieve(id:, params:)
        params[:channel_id] = id
        params
      end

      ##
      # Update Resource
      ##
      def update(id:, params:)
        raise_params_error(param: id, type: 'Integer') unless id.is_a?(Integer)
        raise_params_error(param: params, type: 'Hash') unless params.is_a?(Hash)

        params = update_params(id: id, params: params)
        url = update_url
        Bigcommerce::V3::Response.from_response(response: put_request(url: url, body: params),
                                                object_type: OBJECT_TYPE)
      end

      def update_params(id:, params:)
        params[:channel_id] = id
        params
      end

      def update_url
        RESOURCE_URL
      end
    end
  end
end
