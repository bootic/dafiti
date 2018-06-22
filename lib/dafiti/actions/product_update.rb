require 'dafiti/actions/actions'

module Dafiti
  module Actions
    class ProductUpdate < Post
      escape :Description
    end
  end
end
