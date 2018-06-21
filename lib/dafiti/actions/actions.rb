module Dafiti
  module Actions
    class Action
      def params
        {'Action' => action_name}
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
