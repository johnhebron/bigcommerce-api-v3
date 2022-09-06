# frozen_string_literal: true

module Bigcommerce
  module V3
    ##
    # Base object for holding one or more resource objects
    ##
    class Collection
      attr_reader :data, :total, :count, :per_page,
                  :current_page, :total_pages, :current_page_link,
                  :previous_page_link, :next_page_link

      def self.from_response(response:, object_type:)
        response_data = response.body['data']
        pagination_data = response.body.dig('meta', 'pagination')
        new(
          data: response_data.map { |record| object_type.new(record) },
          pagination_data: pagination_data
        )
      end

      def initialize(data:, pagination_data:)
        @data = data
        pagination_data ||= {}

        handle_pagination_data(pagination_data)
      end

      private

      def value_or_nil(value:)
        value.nil? || value.to_s.empty? ? nil : value.to_s
      end

      def handle_pagination_data(pagination_data)
        @total = value_or_nil(value: pagination_data['total'])
        @count = value_or_nil(value: pagination_data['count'])
        @per_page = value_or_nil(value: pagination_data['per_page'])
        @current_page = value_or_nil(value: pagination_data['current_page'])
        @total_pages = value_or_nil(value: pagination_data['total_pages'])
        @current_page_link = value_or_nil(value: pagination_data.dig('links', 'current'))
        @previous_page_link = value_or_nil(value: pagination_data.dig('links', 'previous'))
        @next_page_link = value_or_nil(value: pagination_data.dig('links', 'next'))
      end
    end
  end
end
