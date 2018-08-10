require 'dafiti/actions/actions'

module Dafiti
  module Actions
    # https://sellerapi.sellercenter.net/docs/productupdate
    class ProductUpdate < Post
      escape :Description

      private

      def prepare_payload(pld)
        prs = pld.fetch(:Product, [])
        prs.is_a?(Hash) ? [prs] : prs

        {
          Product: prs.map {|pr|
            pr.delete(:Variation)
            pr
          }
        }
      end
    end
  end
end
