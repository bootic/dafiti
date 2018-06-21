require 'spec_helper'
require 'dafiti/signature'

RSpec.describe Dafiti::Signature do
  it "computes correct HMAC signature" do
    # https://sellerapi.sellercenter.net/docs/signing-requests
    now = Time.parse('2015-07-01T11:11:11+00:00')
    allow(Time).to receive(:now).and_return now

    signature = described_class.new(
      api_key: 'b1bdb357ced10fe4e9a69840cdd4f0e9c03d77fe',
      user_id: 'look@me.com',
      params: {
        'Action' => 'FeedList',
        'Format' => 'XML',
      }
    )

    expect(signature.signature).to eq '3ceb8ed91049dfc718b0d2d176fb2ed0e5fd74f76c5971f34cdab48412476041'
  end
end
