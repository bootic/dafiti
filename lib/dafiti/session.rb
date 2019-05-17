module Dafiti
  class Session
    PollLimitReachedError = Class.new(StandardError)
    EmptyRequestIdError = Class.new(StandardError)

    PENDING_STATUSES = ['Queued', 'Processing'].freeze
    WAIT_SECONDS = 1
    POLL_LIMIT = 10

    def initialize(client)
      @client = client
    end

    def run(action_name, params = {})
      klass_name = action_name.to_s.split('_').collect(&:capitalize).join
      action_class = Dafiti::Actions.const_get(klass_name)
      action = action_class.new(params)
      client.request(action)
    end

    # run async action and wait for failed or successful feed result
    def run_and_wait(action_name, params = {}, &block)
      times = 0
      result = run(action_name, params)

      unless result.respond_to?(:request_id)
        raise EmptyRequestIdError, "#{result.inspect} does not have #request_id" 
      end

      yield result if block_given?
      
      feed = run(:feed_status, FeedID: result.request_id)
      while PENDING_STATUSES.include?(feed.status)
        times += 1
        if times == POLL_LIMIT
          raise PollLimitReachedError, "waited too long for processed feed with id #{result.request_id}"
        end
        sleep WAIT_SECONDS
        feed = run(:feed_status, FeedID: result.request_id)
      end

      feed
    end

    private
    attr_reader :client
  end
end
