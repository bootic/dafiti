require 'spec_helper'
require 'dafiti/response'

RSpec.describe Dafiti::Response do
  HTTP_RESPONSE = Struct.new(:code, :content_type, :body)
  SUCCESS_RESPONSE = %({
    "SuccessResponse": {
      "Head": {
        "RequestId": "123",
        "RequestAction": "GetProducts",
        "ResponseType": "Products",
        "Timestamp": "2018-06-20T10:11:12"
      },
      "Body": {
        "Products": {
          "Product": [
            {"SellerSku": "ABC"}
          ]
        }
      }
    }
  })
  ERROR_RESPONSE = %({
    "ErrorResponse": {
      "Head": {
        "RequestAction": "Price",
        "ErrorType": "Sender",
        "ErrorCode": 1000,
        "ErrorMessage": "Format Error Detected"
      },
      "Body": {
        "ErrorDetail": {
          "Field": "StandardPrice",
          "Message": "nope!",
          "Value": "10.0x",
          "SellerSku": "ABC"
        }
      }
    }
  })

  context "with success response" do
    it "returns SuccessResponse with data" do
      http = HTTP_RESPONSE.new(
        '200',
        'application/json',
        SUCCESS_RESPONSE
      )
      resp = described_class.instance(http)
      expect(resp).to be_a Dafiti::SuccessResponse
      expect(resp.ok?).to be true
      expect(resp.code).to eq 200
      expect(resp.request_id).to eq '123'
      expect(resp.request_action).to eq 'GetProducts'
      expect(resp.response_type).to eq 'Products'
      expect(resp.timestamp.year).to eq 2018
      expect(resp.body.dig(:Products, :Product).first[:SellerSku]).to eq 'ABC'
    end
  end

  context "with error response" do
    it "returns ErrorResponse with data" do
      http = HTTP_RESPONSE.new(
        '200',
        'application/json',
        ERROR_RESPONSE
      )
      resp = described_class.instance(http)
      expect(resp).to be_a Dafiti::ErrorResponse
      expect(resp.ok?).to be false
      expect(resp.code).to eq 200
      expect(resp.request_action).to eq 'Price'
      expect(resp.error_type).to eq 'Sender'
      expect(resp.error_code).to eq 1000
      expect(resp.error_message).to eq 'Format Error Detected'
      expect(resp.body.dig(:ErrorDetail, :Field)).to eq 'StandardPrice'
    end
  end
end
