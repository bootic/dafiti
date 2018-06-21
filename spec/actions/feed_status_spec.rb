require 'spec_helper'

RSpec.describe Dafiti::Actions::FeedStatus do
  it "works" do
    action = described_class.new(
      FeedID: 'aaabbb',
    )
    expect(action.verb).to eq :get
    expect(action.body).to be nil
    expect(action.params['Action']).to eq 'FeedStatus'
    expect(action.params['FeedID']).to eq 'aaabbb'
  end
end
