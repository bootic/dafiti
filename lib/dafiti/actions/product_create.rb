require 'dafiti/actions/actions'

module Dafiti
  module Actions
    # https://sellerapi.sellercenter.net/docs/productcreate
    class ProductCreate < Post
      escape :Description

      private

      def prepare_payload(pld)
        prs = pld.fetch(:Product, [])
        prs.is_a?(Hash) ? [prs] : prs

        {
          Product: prs
        }
      end
    end
  end
end
