module Dafiti
  module Actions
    class Action
      def initialize(payload = {})
        @payload = payload.each_with_object({}) do |(k, v), o|
          o[k.to_s] = v
        end
      end

      def params
        @payload.merge(
          'Action' => action_name
        )
      end

      def body
        nil
      end

      private
      def action_name
        @action_name ||= self.class.name.split('::').last
      end
    end

    class Get < Action
      def verb
        :get
      end
    end
  end
end
