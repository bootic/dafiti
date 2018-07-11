require 'spec_helper'

RSpec.describe do
  describe ".session" do
    it "works" do
      client = double('Client')
      response = double('Response')
      allow(Dafiti::Client)
        .to receive(:new)
        .with(api_key: 'aaa', user_id: 'cccc')
        .and_return client

      session = Dafiti.session(api_key: 'aaa', user_id: 'cccc')
      expect(client).to receive(:request) do |action|
        expect(action).to be_a Dafiti::Actions::ProductCreate
      end.and_return response

      resp = session.run(:product_create, {})
      expect(resp).to eq response
    end
  end
end
