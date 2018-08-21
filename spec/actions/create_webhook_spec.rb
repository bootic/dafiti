require 'spec_helper'

RSpec.describe Dafiti::Actions::CreateWebhook do
  it "generates XML to create webhook" do
    action = described_class.new(
      Webhook: {
        CallbackUrl: 'https://server.com',
        Events: {
          Event: [
            'onOrderCreated',
            'onProductCreated',
          ]
        }
      }
    )

    expect(action.verb).to eq :post
    expect(action.params['Action']).to eq 'CreateWebhook'
    expect_equal_xml(action.body, %(<?xml version="1.0" encoding="UTF-8"?>
<Request>
  <Webhook>
    <CallbackUrl>https://server.com</CallbackUrl>
    <Events>
      <Event>onOrderCreated</Event>
      <Event>onProductCreated</Event>
    </Events>
  </Webhook>
</Request>))
  end
end
