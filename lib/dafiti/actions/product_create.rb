require 'dafiti/actions/actions'

module Dafiti
  module Actions
    class ProductCreate < Post
      escape :Description
    end
  end
end
