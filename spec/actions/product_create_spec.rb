require 'spec_helper'

RSpec.describe Dafiti::Actions::ProductCreate do
  it "generates XML to add product" do
    action = described_class.new(
      Product: {
        SellerSku: "4105382173aaee4",
        ParentSku: "BBB",
        Status: "active",
        Name: "Magic Product",
        Variation: "XXL",
        PrimaryCategory: 4,
        Categories: "2,3,5",
        Description: "A description",
        Brand: "ASM",
        Price: "100.00",
        SalePrice: 32.5,
        SaleStartDate: "2013-09-03T11:31:23+00:00",
        SaleEndDate: "2013-10-03T11:31:23+00:00",
        ShipmentType: "dropshipping",
        ProductId: "xyzabc",
        Condition: "new",
        ProductData: {
          Megapixels: 490,
          OpticalZoom: 7,
          SystemMemory: 4,
          NumberCpus: 32,
          Network: "This is network"
        },
        Quantity: 10
      }
    )

    expect(action.verb).to eq :post
    expect(action.params['Action']).to eq 'ProductCreate'
    expect_equal_xml(action.body, %(<?xml version="1.0" encoding="UTF-8"?>
<Request>
  <Product>
    <SellerSku>4105382173aaee4</SellerSku>
    <ParentSku>BBB</ParentSku>
    <Status>active</Status>
    <Name>Magic Product</Name>
    <Variation>XXL</Variation>
    <PrimaryCategory>4</PrimaryCategory>
    <Categories>2,3,5</Categories>
    <Description>
      <![CDATA[A description]]>
    </Description>
    <Brand>ASM</Brand>
    <Price>100.00</Price>
    <SalePrice>32.5</SalePrice>
    <SaleStartDate>2013-09-03T11:31:23+00:00</SaleStartDate>
    <SaleEndDate>2013-10-03T11:31:23+00:00</SaleEndDate>
    <ShipmentType>dropshipping</ShipmentType>
    <ProductId>xyzabc</ProductId>
    <Condition>new</Condition>
    <ProductData>
      <Megapixels>490</Megapixels>
      <OpticalZoom>7</OpticalZoom>
      <SystemMemory>4</SystemMemory>
      <NumberCpus>32</NumberCpus>
      <Network>This is network</Network>
    </ProductData>
    <Quantity>10</Quantity>
  </Product>
</Request>))
  end
end
