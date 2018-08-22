require 'spec_helper'

RSpec.describe Dafiti::Session do
  let(:client) { double("Dafiti::Client") }

  describe "#run" do
    it "run correct action" do
      session = described_class.new(client)
      response = double('Response')

      expect(client).to receive(:request) do |action|
        expect(action).to be_a Dafiti::Actions::FeedList
      end.and_return response

      expect(session.run(:feed_list, FeedListId: 123)).to eq response
    end
  end
end
