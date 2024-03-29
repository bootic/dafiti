require 'net/http'
require 'uri'
require_relative './version'
require_relative './signature'
require_relative './responses'

module Dafiti
  class Client
    UA = "Dafiti Ruby Client #{VERSION} - #{RUBY_VERSION} #{RUBY_PLATFORM}".freeze
    CONTENT_TYPE = 'application/x-www-form-urlencoded'.freeze
    BASE_URL = 'https://sellercenter.dafiti.cl'.freeze
    DEFAULT_PARAMS = {'Format' => 'JSON'}.freeze
    HTTP_METHODS = {
      get: Net::HTTP::Get,
      post: Net::HTTP::Post,
    }

    def initialize(api_key:, user_id:, base_url: BASE_URL, user_agent: UA)
      @api_key = api_key
      @user_id = user_id
      @base_url = base_url
      @user_agent = user_agent
    end

    def request(action, &block)
      uri = URI.parse(base_url)
      signature = Signature.new(
        api_key: api_key,
        user_id: user_id,
        params: action.params.merge(DEFAULT_PARAMS)
      )

      uri.query = signature.query_string

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = HTTP_METHODS.fetch(action.verb).new(uri.request_uri)
      request['Content-Type'] = CONTENT_TYPE
      request['User-Agent'] = @user_agent
      if uri.user && uri.password
        request.basic_auth uri.user, uri.password
      end
      if action.body
        request.body = action.body.to_s
      end
      yield(request) if block_given?

      response = http.request(request)
      Responses::Response.instance(response)
    end

    private
    attr_reader :api_key, :user_id, :basic_auth, :base_url
  end
end
