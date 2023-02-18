# frozen_string_literal: true

module Bigcommerce
  module V3
    ##
    # wrapper around Faraday HTTP client
    ##
    class Connection
      MS_UNTIL_RESET_HEADER = 'x-rate-limit-time-reset-ms'
      MAX_RETRIES = 2

      attr :retry_count, :ms_until_reset, :connection

      def initialize(config:)
        @retry_count = 0
        @ms_until_reset = nil
        @connection = new_connection(config: config)
      end

      def get(url, params, headers)
        handle_request(verb: :get, url: url, params: params, headers: headers)
      end

      def post(url, body, headers)
        handle_request(verb: :post, url: url, body: body, headers: headers)
      end

      def put(url, body, headers)
        handle_request(verb: :put, url: url, body: body, headers: headers)
      end

      def delete(url, params, headers)
        handle_request(verb: :delete, url: url, params: params, headers: headers)
      end

      private

      def new_connection(config:)
        Faraday.new(url: config.full_api_path) do |conn|
          conn.headers = config.http_headers
          conn.request :json
          conn.response :json
          configure_logger(conn, config)
          # Adapter must be last
          conn.adapter config.adapter, config.stubs
        end
      end

      def handle_request(verb:, url:, headers:, params: {}, body: {})
        @retry_count = 0
        @ms_until_reset = nil
        response = nil

        loop do
          response = make_request(verb: verb, url: url, headers: headers, params: params, body: body)

          break unless response.status.to_i == 429

          sleep_for_retry(response)
          break if @retry_count >= MAX_RETRIES
        end

        response
      end

      def make_request(verb:, url:, headers:, params: {}, body: {})
        case verb
        when :get, :delete
          connection.send(verb, url, params, headers)
        when :post, :put
          connection.send(verb, url, body, headers)
        else
          raise Bigcommerce::V3::Error::HTTPError, "Invalid HTTP method provided for request: [#{verb}]"
        end
      end

      def sleep_for_retry(response)
        response.headers.map do |key, value|
          @ms_until_reset = value.to_i if key.downcase == MS_UNTIL_RESET_HEADER
        end

        sleep seconds_to_sleep if seconds_to_sleep
        @retry_count += 1
      end

      def seconds_to_sleep
        @ms_until_reset.is_a?(Integer) ? @ms_until_reset / 1_000 : nil
      end

      def configure_logger(conn, config)
        return unless config.logger

        conn.response :logger, nil, { headers: true, bodies: true } do |logger|
          logger.filter(/(X-Auth-Token: )([^&]+)/, '\1[REMOVED]')
        end
      end
    end
  end
end
