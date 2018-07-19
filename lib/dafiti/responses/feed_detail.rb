require 'dafiti/responses'
module Dafiti
  module Responses
    class FeedDetail < SuccessResponse
      def status
        detail.fetch(:Status)
      end

      def errors
        @errors ||= Array(detail.fetch(:FeedErrors, {}).fetch(:Error, []))
      end

      private
      def detail
        body.fetch(:FeedDetail)
      end
    end

    registry[:FeedDetail] = FeedDetail
  end
end
