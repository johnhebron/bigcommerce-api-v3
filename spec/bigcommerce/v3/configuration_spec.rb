# frozen_string_literal: true

require "./spec/spec_helper"

describe "Bigcommerce::V3::Configuration" do
  context "#initialize" do
    context "with a valid store_hash and access_token" do
      let(:config) { Bigcommerce::V3::Configuration.new(store_hash: "string", access_token: "string") }

      it "should be of type Bigcommerce::V3::Configuration" do
        expect(config).to be_a_kind_of(Bigcommerce::V3::Configuration)
      end
    end

    context "without a nil store_hash or access_token" do
      let(:config) { Bigcommerce::V3::Configuration.new(store_hash: nil, access_token: nil) }

      it "should raise an error" do
        expect { config }.to raise_error(Bigcommerce::V3::Error)
      end
    end

    context "without an empty store_hash or access_token" do
      let(:config) { Bigcommerce::V3::Configuration.new(store_hash: "", access_token: "") }

      it "should raise an error" do
        expect { config }.to raise_error(Bigcommerce::V3::Error)
      end
    end
  end

  context ".full_api_path" do
    let(:store_hash) { "d84jfkd" }
    let(:access_token) { "uu44hhr8837dghf84u" }
    let(:config) { Bigcommerce::V3::Configuration.new(store_hash: store_hash, access_token: access_token) }
    let(:base_api_path) { Bigcommerce::V3::Configuration::BASE_API_PATH }
    let(:v3_path) { Bigcommerce::V3::Configuration::V3_API_PATH }

    it "should return a correctly formatted api path" do
      expect(config.full_api_path).to eq("#{base_api_path}#{store_hash}/#{v3_path}")
    end
  end
end
