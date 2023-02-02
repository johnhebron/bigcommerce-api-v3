# frozen_string_literal: true

module Helpers
  def stub_request(path:, response:, verb: :get, body: {})
    Faraday::Adapter::Test::Stubs.new do |stub|
      case verb.to_sym
      when :get, :delete
        stub.send(verb.to_sym, path) { |_env| response }
      when :post, :put
        stub.send(verb.to_sym, path, body) { |_env| response }
      end
    end
  end

  def stub_response(fixture:, status: 200, headers: {})
    headers.merge!(default_headers)

    if fixture.nil? || fixture.empty?
      [status, headers, '']
    else
      fixture_path = "spec/fixtures/#{fixture}.json"
      [status, headers, File.read(fixture_path)]
    end
  end

  def default_headers
    { 'Content-Type' => 'application/json' }
  end
end
