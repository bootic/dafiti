require 'spec_helper'
require 'dafiti/signature'

RSpec.describe Dafiti::Signature do
  TEST_SIGNATURE = '3ceb8ed91049dfc718b0d2d176fb2ed0e5fd74f76c5971f34cdab48412476041'.freeze
  let(:test_time) { '2015-07-01T11:11:11+00:00' }

  let(:now) { Time.parse(test_time) }
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

  it 'handles array params correctly' do
    signature = described_class.new(
      api_key: 'b1bdb357ced10fe4e9a69840cdd4f0e9c03d77fe',
      user_id: 'look@me.com',
      params: {
        'Action' => 'FeedList',
        'Format' => 'JSON',
        'SellerSKUList' => ['aa', 'bb', 'cc']
      }
    )
 
    q = signature.query_string
    expect(q).to eq 'Action=FeedList&Format=JSON&SellerSKUList=%5B%22aa%22%2C%22bb%22%2C%22cc%22%5D&Timestamp=2015-07-01T11%3A11%3A11%2B00%3A00&UserID=look%40me.com&Version=1.0&Signature=d5ace21b558e92f6435ff9f9bd01936f09b78bf59668f6ece8b5fe5bed361cda'
  end

end
