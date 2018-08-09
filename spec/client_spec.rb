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
    stub_feedlist.
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
    expect(resp).to be_a Dafiti::Responses::SuccessResponse
    expect(resp.request_action).to eq 'FeedList'
    expect(resp.response_type).to eq 'Feed'
    expect(resp.body).to eq({})
  end

  it "wraps response in registered class, if any" do
    json_response = %({
      "SuccessResponse": {
        "Head": {
          "RequestId": "",
          "RequestAction": "FeedStatus",
          "ResponseType": "FeedDetail",
          "Timestamp": "2018-06-21T12:33:05-0400"
        },
        "Body": {
          "FeedDetail": {
            "Feed": "feed123",
            "Status": "Finished",
            "FailedRecords": 1,
            "FeedErrors": {
              "Error": [
                {"Code": "0", "Message": "nope1", "SellerSku": "SKU1"},
                {"Code": "1", "Message": "nope2", "SellerSku": "SKU1"}
              ]
            }
          }
        }
      }
    })

    stub_feedstatus.
      with(headers: {'Content-Type' => 'application/x-www-form-urlencoded'}).
      to_return(
        status: 200,
        headers: {'Content-Type' => 'application/json'},
        body: json_response,
      )

    action = Action.new(
      :get,
      nil,
      {
        'Action' => 'FeedStatus'
      }
    )

    resp = client.request(action)
    expect(resp).to be_a Dafiti::Responses::FeedDetail
    expect(resp.request_action).to eq 'FeedStatus'
    expect(resp.response_type).to eq 'FeedDetail'
    expect(resp.status).to eq 'Finished'
    expect(resp.body[:FeedDetail][:Feed]).to eq('feed123')
    expect(resp.errors[0][:Message]).to eq 'nope1'
  end

  it "wraps errors correctly" do
    json_response = %({
      "SuccessResponse": {
        "Head": {
          "RequestId": "",
          "RequestAction": "FeedStatus",
          "ResponseType": "FeedDetail",
          "Timestamp": "2018-06-21T12:33:05-0400"
        },
        "Body": {
          "FeedDetail": {
            "Feed": "feed123",
            "Status": "Finished",
            "FailedRecords": 1,
            "FeedErrors": {
              "Error": {"Code": "0", "Message": "nope1", "SellerSku": "SKU1"}
            }
          }
        }
      }
    })

    stub_feedstatus.
      with(headers: {'Content-Type' => 'application/x-www-form-urlencoded'}).
      to_return(
        status: 200,
        headers: {'Content-Type' => 'application/json'},
        body: json_response,
      )

    action = Action.new(
      :get,
      nil,
      {
        'Action' => 'FeedStatus'
      }
    )

    resp = client.request(action)
    expect(resp.errors[0][:Message]).to eq 'nope1'
  end

  it "uses Basic Auth, if URL includes credentials" do
    client = described_class.new(
      api_key: 'b1bdb357ced10fe4e9a69840cdd4f0e9c03d77fe',
      user_id: 'look@me.com',
      base_url: 'https://foo:bar@sellercenter.dafiti.cl'
    )

    stub_feedlist.
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
    expect(resp).to be_a Dafiti::Responses::SuccessResponse
  end

  it "POSTs XML payload if action supports it" do
    stub_product_udpate.
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
    expect(resp).to be_a Dafiti::Responses::SuccessResponse
  end

  it "raises if status code not successful" do
    stub_feedlist.
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

  def stub_feedlist
    stub_request(:get, "https://sellercenter.dafiti.cl/?Action=Feedlist&Format=JSON&Signature=0b5bbfd36b672577e04c5b0f1b33c70ac10c585d8c08339f782fcb501b529d68&Timestamp=2015-07-01T11:11:11%2B00:00&UserID=look@me.com&Version=1.0")
  end

  def stub_feedstatus
    stub_request(:get, "https://sellercenter.dafiti.cl/?Action=FeedStatus&Format=JSON&Signature=3bd6b0a4f47ec743b18b182cc53ef13226a6a3cea18127923eb77e13c9dc302d&Timestamp=2015-07-01T11:11:11%2B00:00&UserID=look@me.com&Version=1.0")
  end

  def stub_product_udpate
    stub_request(:post, "https://sellercenter.dafiti.cl/?Action=ProductUpdate&Format=JSON&Signature=e601cd399a0a2b27cc214e489f115ef9d2ae0e9b735813fb6062f9766d17579e&Timestamp=2015-07-01T11:11:11%2B00:00&UserID=look@me.com&Version=1.0")
  end
end
