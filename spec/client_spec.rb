require 'spec_helper'
require 'dafiti'

RSpec.describe Dafiti::Client do
  Action = Struct.new(:verb, :body, :params)
  let(:test_time) { '2015-07-01T11:11:11+00:00' }
  let(:success_response) do
    %({
      "SuccessResponse": {
        "Head": {
          "RequestId": "",
          "RequestAction": "FeedList",
          "ResponseType": "Feed",
          "Timestamp": "2018-06-21T12:33:05-0400"
        },
        "Body": ""
      }
    })
  end
  let(:post_body) do
    %(<?xml version="1.0" encoding="UTF-8" ?>
<Request>
  <Product>
    <SellerSku>4105382173aaee4</SellerSku>
    <Price>12</Price>
  </Product>
  <Product>
    <SellerSku>4928a374c28ff1</SellerSku>
    <Quantity>4</Quantity>
  </Product>
</Request>)
  end

  let(:now) { Time.parse(test_time) }
  let(:client) do
    described_class.new(
      api_key: 'b1bdb357ced10fe4e9a69840cdd4f0e9c03d77fe',
      user_id: 'look@me.com',
    )
  end

  before do
    allow(Time).to receive(:now).and_return now
  end

  it "works" do
    stub_request(:get, "https://sellercenter.dafiti.cl/?Action=Feedlist&Format=JSON&Signature=0b5bbfd36b672577e04c5b0f1b33c70ac10c585d8c08339f782fcb501b529d68&Timestamp=2015-07-01T11:11:11%2B00:00&UserID=look@me.com&Version=1.0").
      with(headers: {'Content-Type' => 'application/x-www-form-urlencoded'}).
      to_return(
        status: 200,
        headers: {'Content-Type' => 'application/json'},
        body: success_response,
      )

    action = Action.new(
      :get,
      nil,
      {
        'Action' => 'Feedlist'
      }
    )

    resp = client.request(action)
    expect(resp).to be_a Dafiti::SuccessResponse
    expect(resp.request_action).to eq 'FeedList'
    expect(resp.response_type).to eq 'Feed'
    expect(resp.body).to eq({})
  end

  it "uses Basic Auth, if URL includes credentials" do
    client = described_class.new(
      api_key: 'b1bdb357ced10fe4e9a69840cdd4f0e9c03d77fe',
      user_id: 'look@me.com',
      base_url: 'https://foo:bar@sellercenter.dafiti.cl'
    )

    stub_request(:get, "https://sellercenter.dafiti.cl/?Action=Feedlist&Format=JSON&Signature=0b5bbfd36b672577e04c5b0f1b33c70ac10c585d8c08339f782fcb501b529d68&Timestamp=2015-07-01T11:11:11%2B00:00&UserID=look@me.com&Version=1.0").
      with(basic_auth: ['foo', 'bar']).
      to_return(
        status: 200,
        headers: {'Content-Type' => 'application/json'},
        body: success_response,
      )

    action = Action.new(
      :get,
      nil,
      {
        'Action' => 'Feedlist'
      }
    )

    resp = client.request(action)
    expect(resp).to be_a Dafiti::SuccessResponse
  end

  it "POSTs XML payload if action supports it" do
    stub_request(:post, "https://sellercenter.dafiti.cl/?Action=ProductUpdate&Format=JSON&Signature=e601cd399a0a2b27cc214e489f115ef9d2ae0e9b735813fb6062f9766d17579e&Timestamp=2015-07-01T11:11:11%2B00:00&UserID=look@me.com&Version=1.0").
      with(headers: {'Content-Type' => 'application/x-www-form-urlencoded'}, body: post_body).
      to_return(
        status: 200,
        headers: {'Content-Type' => 'application/json'},
        body: success_response,
      )

    action = Action.new(
      :post,
      post_body,
      {
        'Action' => 'ProductUpdate'
      }
    )

    resp = client.request(action)
    expect(resp).to be_a Dafiti::SuccessResponse
  end

  it "raises if status code not successful" do
    stub_request(:get, "https://sellercenter.dafiti.cl/?Action=Feedlist&Format=JSON&Signature=0b5bbfd36b672577e04c5b0f1b33c70ac10c585d8c08339f782fcb501b529d68&Timestamp=2015-07-01T11:11:11%2B00:00&UserID=look@me.com&Version=1.0").
      with(headers: {'Content-Type' => 'application/x-www-form-urlencoded'}).
      to_return(
        status: 500,
        headers: {'Content-Type' => 'application/json'},
        body: success_response,
      )

    action = Action.new(
      :get,
      nil,
      {
        'Action' => 'Feedlist'
      }
    )

    expect {
      client.request(action)
    }.to raise_error Dafiti::ServerError
  end
end
