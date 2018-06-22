require 'spec_helper'

RSpec.describe Dafiti::Actions::Image do
  it "works with a single product with single image" do
    action = described_class.new(
     ProductImage: {
       SellerSku: "ABC",
       Images: {
         Image: "https://images.com/1.jpg"
       }
     }
    )
    expect(action.verb).to eq :post
    expect(action.params['Action']).to eq 'Image'
    expect_equal_xml(action.body, %(<?xml version="1.0" encoding="UTF-8"?>
<Request>
  <ProductImage>
    <SellerSku>ABC</SellerSku>
    <Images>
      <Image>https://images.com/1.jpg</Image>
    </Images>
  </ProductImage>
</Request>))
  end

  it "works with a single product with many images" do
    action = described_class.new(
     ProductImage: {
       SellerSku: "ABC",
       Images: {
        Image: [
          "https://images.com/1.jpg",
          "https://images.com/2.jpg",
        ]
       }
     }
    )
    expect_equal_xml(action.body, %(<?xml version="1.0" encoding="UTF-8"?>
<Request>
  <ProductImage>
    <SellerSku>ABC</SellerSku>
    <Images>
      <Image>https://images.com/1.jpg</Image>
      <Image>https://images.com/2.jpg</Image>
    </Images>
  </ProductImage>
</Request>))
  end

  it "works with many products with many images" do
    action = described_class.new(
     ProductImage: [
       {
         SellerSku: "AAA",
         Images: {
          Image: [
            "https://images.com/1.jpg",
            "https://images.com/2.jpg",
          ]
         }
       },
       {
         SellerSku: "BBB",
         Images: {
          Image: "https://images.com/3.jpg",
         }
       }
     ]
    )
    expect_equal_xml(action.body, %(<?xml version="1.0" encoding="UTF-8"?>
<Request>
  <ProductImage>
    <SellerSku>AAA</SellerSku>
    <Images>
      <Image>https://images.com/1.jpg</Image>
      <Image>https://images.com/2.jpg</Image>
    </Images>
  </ProductImage>
  <ProductImage>
    <SellerSku>BBB</SellerSku>
    <Images>
      <Image>https://images.com/3.jpg</Image>
    </Images>
  </ProductImage>
</Request>))
  end
end
