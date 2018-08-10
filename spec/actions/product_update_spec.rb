require 'spec_helper'

RSpec.describe Dafiti::Actions::ProductUpdate do
  it "works" do
    # takes same payload as ProductCreate
    action = described_class.new
    expect(action.verb).to eq :post
    expect(action.params['Action']).to eq 'ProductUpdate'
  end

  it "removes product variations from payload, which cause conflicts" do
    payload = {
      Product: [
        {
          SellerSku: "un-producto-bootic-v1", # parent SKU
          # ParentSku: "ABC123456",
          Status: "active",
          Name: "Magic Product",
          Variation: "35", # restricted
          # primary cat. must be level 3, for some reason
          PrimaryCategory: 145, # Zapatos/Zapatos Mujer/Botines, taken from GetCategoryTree
          Description: "A description",
          Brand: "Romano",
          Price: "100.00", # only once in parent SKU
          Condition: "new",
          Quantity: 10,
          ProductData: {}
        },
        {
          # ParentSku: "un-producto-bootic-v1",
          SellerSku: "un-producto-bootic-v2",
          Name: "Magic Product",
          Variation: "36",
          PrimaryCategory: 145,
          Description: "A description",
          Brand: "Romano",
          Price: "200.00",
          Quantity: 4,
          ProductData: {}
        }
      ]
    }

    action = described_class.new(payload)
    expect_equal_xml(action.body, %(<?xml version="1.0" encoding="UTF-8"?>
<Request>
  <Product>
    <SellerSku>un-producto-bootic-v1</SellerSku>
    <Status>active</Status>
    <Name>Magic Product</Name>
    <PrimaryCategory>145</PrimaryCategory>
    <Description>
      <![CDATA[A description]]>
    </Description>
    <Brand>Romano</Brand>
    <Price>100.00</Price>
    <Condition>new</Condition>
    <Quantity>10</Quantity>
    <ProductData></ProductData>
  </Product>
  <Product>
    <SellerSku>un-producto-bootic-v2</SellerSku>
    <Name>Magic Product</Name>
    <PrimaryCategory>145</PrimaryCategory>
    <Description>
      <![CDATA[A description]]>
    </Description>
    <Brand>Romano</Brand>
    <Price>200.00</Price>
    <Quantity>4</Quantity>
    <ProductData></ProductData>
  </Product>
</Request>))
  end
end
