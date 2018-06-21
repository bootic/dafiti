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

  let(:now) { Time.parse(test_time) }

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

    client = described_class.new(
      api_key: 'b1bdb357ced10fe4e9a69840cdd4f0e9c03d77fe',
      user_id: 'look@me.com',
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

  it "raises if status code not successful" do
    stub_request(:get, "https://sellercenter.dafiti.cl/?Action=Feedlist&Format=JSON&Signature=0b5bbfd36b672577e04c5b0f1b33c70ac10c585d8c08339f782fcb501b529d68&Timestamp=2015-07-01T11:11:11%2B00:00&UserID=look@me.com&Version=1.0").
      with(headers: {'Content-Type' => 'application/x-www-form-urlencoded'}).
      to_return(
        status: 500,
        headers: {'Content-Type' => 'application/json'},
        body: success_response,
      )

    client = described_class.new(
      api_key: 'b1bdb357ced10fe4e9a69840cdd4f0e9c03d77fe',
      user_id: 'look@me.com',
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
