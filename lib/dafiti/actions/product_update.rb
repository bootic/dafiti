require 'dafiti/actions/actions'

module Dafiti
  module Actions
    # https://sellerapi.sellercenter.net/docs/productupdate
    class ProductUpdate < Post
      escape :Description
    end
  end
end
