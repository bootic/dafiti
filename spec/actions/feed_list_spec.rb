require 'spec_helper'
require 'dafiti/actions/feed_list'

RSpec.describe Dafiti::Actions::FeedList do
  it "works" do
    action = described_class.new
    expect(action.verb).to eq :get
    expect(action.body).to be nil
    expect(action.params['Action']).to eq 'FeedList'
  end
end
