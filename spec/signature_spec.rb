require 'spec_helper'
require 'dafiti/signature'

RSpec.describe Dafiti::Signature do
  TEST_SIGNATURE = '3ceb8ed91049dfc718b0d2d176fb2ed0e5fd74f76c5971f34cdab48412476041'.freeze
  TEST_TIME = '2015-07-01T11:11:11+00:00'.freeze

  let(:now) { Time.parse(TEST_TIME) }
  let(:signature) do
    described_class.new(
      api_key: 'b1bdb357ced10fe4e9a69840cdd4f0e9c03d77fe',
      user_id: 'look@me.com',
      params: {
        'Action' => 'FeedList',
        'Format' => 'XML',
      }
    )
  end

  before do
    allow(Time).to receive(:now).and_return now
  end

  it "computes correct HMAC signature" do
    # https://sellerapi.sellercenter.net/docs/signing-requests
    expect(signature.signature).to eq TEST_SIGNATURE
  end

  it "computes different signature if params change" do
    signature = described_class.new(
      api_key: 'b1bdb357ced10fe4e9a69840cdd4f0e9c03d77fe',
      user_id: 'look@me.com',
      params: {
        'Action' => 'FeedList',
        'Format' => 'JSON',
      }
    )

    expect(signature.signature).not_to eq TEST_SIGNATURE
  end

  it "generates full query string with signature" do
    q = signature.query_string
    expect(q).to eq 'Action=FeedList&Format=XML&Timestamp=2015-07-01T11%3A11%3A11%2B00%3A00&UserID=look%40me.com&Version=1.0&Signature=3ceb8ed91049dfc718b0d2d176fb2ed0e5fd74f76c5971f34cdab48412476041'
  end
end
