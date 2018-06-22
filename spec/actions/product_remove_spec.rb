require 'spec_helper'

RSpec.describe Dafiti::Actions::ProductRemove do
  it "works with a single product" do
    action = described_class.new(
     Product: {
       SellerSku: "ABC"
     }
    )
    expect(action.verb).to eq :post
    expect(action.params['Action']).to eq 'ProductRemove'
    expect_equal_xml(action.body, %(<?xml version="1.0" encoding="UTF-8"?>
<Request>
  <Product>
    <SellerSku>ABC</SellerSku>
  </Product>
</Request>))
  end

  it "works for multiple products" do
    action = described_class.new(
     Product: [
       {SellerSku: "FOO"},
       {SellerSku: "BAR"},
     ]
    )
    expect_equal_xml(action.body, %(<?xml version="1.0" encoding="UTF-8"?>
<Request>
  <Product>
    <SellerSku>FOO</SellerSku>
  </Product>
  <Product>
    <SellerSku>BAR</SellerSku>
  </Product>
</Request>))
  end
end
