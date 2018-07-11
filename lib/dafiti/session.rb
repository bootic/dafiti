module Dafiti
  class Session
    def initialize(client)
      @client = client
    end

    def run(action_name, params = {})
      klass_name = action_name.to_s.split('_').collect(&:capitalize).join
      action_class = Dafiti::Actions.const_get(klass_name)
      action = action_class.new(params)
      client.request(action)
    end

    private
    attr_reader :client
  end
end
