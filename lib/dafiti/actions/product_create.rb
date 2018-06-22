require 'dafiti/actions/actions'

module Dafiti
  module Actions
    # https://sellerapi.sellercenter.net/docs/productcreate
    class ProductCreate < Post
      escape :Description
    end
  end
end
