require 'dafiti/responses'
module Dafiti
  module Responses
    class FeedDetail < SuccessResponse
      def status
        detail.fetch(:Status)
      end

      def ok?
        !errors.any?
      end

      def errors
        @errors ||= (
          errs = detail.fetch(:FeedErrors, {}).fetch(:Error, [])
          errs.is_a?(Array) ? errs : [errs]
        )
      end

      private
      def detail
        body.fetch(:FeedDetail)
      end
    end

    registry[:FeedDetail] = FeedDetail
  end
end
