require 'spec_helper'

RSpec.describe Dafiti::Actions::ProductUpdate do
  it "works" do
    # takes same payload as ProductCreate
    action = described_class.new
    expect(action.verb).to eq :post
    expect(action.params['Action']).to eq 'ProductUpdate'
  end
end
