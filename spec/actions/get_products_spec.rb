require 'spec_helper'

RSpec.describe Dafiti::Actions::GetProducts do
  it "works" do
    action = described_class.new(
      CreatedAfter: '2018-06-20T10:11:12',
      CreatedBefore: '2018-06-21T10:00:00',
    )
    expect(action.verb).to eq :get
    expect(action.body).to be nil
    expect(action.params['Action']).to eq 'GetProducts'
    expect(action.params['CreatedAfter']).to eq '2018-06-20T10:11:12'
    expect(action.params['CreatedBefore']).to eq '2018-06-21T10:00:00'
  end
end
