# frozen_string_literal: true

module Bigcommerce
  module V3
    ##
    # Object for holding response data + response metadata
    ##
    class Response
      attr_reader :body, :headers, :status,
                  :data, :error,
                  :total, :count, :per_page, :current_page, :total_pages,
                  :current_page_link, :previous_page_link, :next_page_link

      # Simple error message object for http response error
      ErrorMessage = Struct.new(:status, :title, :type, :detail, :errors)

      def self.from_response(response:, object_type:)
        errors = validate_response(response: response)
        raise Error::InvalidArguments, "Invalid response provided. Error(s): #{errors.join(', ')}" if errors

        new(body: response.body, headers: response.headers, status: response.status, object_type: object_type)
      end

      def initialize(body:, headers:, status:, object_type:)
        errors = validate_params(headers: headers, status: status, object_type: object_type)
        raise Error::InvalidArguments, errors.join(', ') if errors

        @body = body || {}
        @headers = headers
        @status = status.to_i
        @data = transform_data(body, object_type)
        transform_pagination_data(body)
        @error = transform_error(body)
      end

      def success?
        @status.between?(200, 299)
      end

      def self.validate_response(response:)
        errors = []
        errors << "doesn't respond to .body" unless response.respond_to?(:body)
        errors << "doesn't respond to .headers" unless response.respond_to?(:headers)
        errors << "doesn't respond to .status" unless response.respond_to?(:status)

        errors.empty? ? false : errors
      end

      private_class_method :validate_response

      private

      def validate_params(headers:, status:, object_type:)
        errors = []
        errors << 'headers can not be nil' if headers.nil?
        errors << 'status can not be nil' if status.nil?
        errors << "object_type must be a valid object_type, #{object_type.class} provided" unless object_type.is_a?(Class)

        errors.empty? ? false : errors
      end

      def value_or_nil(value:)
        value.nil? || value.to_s.empty? ? nil : value.to_s
      end

      def transform_pagination_data(body)
        pagination_data = if body.is_a?(Hash)
                            body.dig('meta', 'pagination') || {}
                          else
                            {}
                          end

        @total = value_or_nil(value: pagination_data['total'])
        @count = value_or_nil(value: pagination_data['count'])
        @per_page = value_or_nil(value: pagination_data['per_page'])
        @current_page = value_or_nil(value: pagination_data['current_page'])
        @total_pages = value_or_nil(value: pagination_data['total_pages'])
        @current_page_link = value_or_nil(value: pagination_data.dig('links', 'current'))
        @previous_page_link = value_or_nil(value: pagination_data.dig('links', 'previous'))
        @next_page_link = value_or_nil(value: pagination_data.dig('links', 'next'))
      end

      def transform_data(body, object_type)
        if body.is_a?(Hash) && body['data'].is_a?(Array)
          body['data']&.map { |record| object_type.new(record) }
        elsif body.is_a?(Hash) && body['data'].is_a?(Hash)
          [object_type.new(body['data'])]
        else
          {}
        end
      end

      def transform_error(body)
        return nil unless body.is_a?(Hash) && body['status']

        ErrorMessage.new(body['status'], body['title'], body['type'], body['detail'], body['errors'])
      end
    end
  end
end
