# frozen_string_literal: true

module Bigcommerce
  module V3
    ##
    # HTTP client for interacting with the BigCommerce HTTP API
    ##
    class Client
      attr_reader :config, :conn

      def initialize(store_hash: nil, access_token: nil, config: nil)
        if config.nil?
          validate_params(store_hash: store_hash, access_token: access_token)
          @config = Configuration.new(store_hash: store_hash, access_token: access_token)
        else
          @config = config
        end

        @conn = Bigcommerce::V3::Connection.new(config: @config)
      end

      def abandoned_cart_emails
        AbandonedCartEmailsResource.new(client: self)
      end

      def abandoned_cart_email_settings
        AbandonedCartEmailSettingsResource.new(client: self)
      end

      def customers
        CustomersResource.new(client: self)
      end

      def pages
        PagesResource.new(client: self)
      end

      private

      def validate_params(store_hash:, access_token:)
        return unless store_hash.nil? || access_token.nil? || store_hash.empty? || access_token.empty?

        raise Error::ClientConfigError, 'Valid Configuration object or store_hash/access_token required.'
      end
    end
  end
end
