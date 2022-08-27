# frozen_string_literal: true

module Bigcommerce
  module V3
    ##
    # Base entity for individual resource actions to inherit from
    ##
    class Resource
      attr_reader :client

      def initialize(client:)
        @client = client
      end

      def get_request(url:)
        client.conn.get(url)
      end
    end
  end
end
