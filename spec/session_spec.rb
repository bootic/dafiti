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

  describe "#run_and_wait" do
    it "explodes if request doesnt have a request_id" do
      session = described_class.new(client)
      response = double('Response')

      expect(client).to receive(:request) do |action|
        expect(action).to be_a Dafiti::Actions::FeedList
      end.and_return response

      expect do
        session.run_and_wait(:feed_list, FeedListId: 123)
      end.to raise_error RuntimeError
    end

    it "runs action" do
      session = described_class.new(client)

      response_one = double('Response', request_id: 1234)
      expect(client).to receive(:request) do |action|
        expect(action).to be_a Dafiti::Actions::FeedList
      end.once.and_return response_one

      response_two = double('Response', status: 'OK') # not queued/processing
      expect(client).to receive(:request) do |action|
        expect(action).to be_a Dafiti::Actions::FeedStatus
      end.once.and_return response_two

      expect(session.run_and_wait(:feed_list, FeedListId: 123)).to eq response_two
    end

    it "yields block if passed" do
      session = described_class.new(client)

      response_one = double('Response', request_id: 1234)
      expect(client).to receive(:request) do |action|
        expect(action).to be_a Dafiti::Actions::FeedList
      end.once.and_return response_one

      response_two = double('Response', status: 'OK') # not queued/processing
      expect(client).to receive(:request) do |action|
        expect(action).to be_a Dafiti::Actions::FeedStatus
      end.once.and_return response_two

      session.run_and_wait(:feed_list, FeedListId: 123) do |resp|
        expect(resp).to eq response_one
      end
    end
  end

end
