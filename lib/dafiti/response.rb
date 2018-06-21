require 'json'
require 'time'

module Dafiti
  class Response
    JSON_MIME = /application\/json/.freeze
    VALID_STATUSES = (200..299).freeze
    SUCCESS_KEY = :SuccessResponse
    ERROR_KEY = :ErrorResponse

    def self.instance(response)
      http_ok = VALID_STATUSES.include?(response.code.to_i)
      # if not http ok should not even try to parse body, could be anything. Raise?
      data = if response.content_type =~ JSON_MIME
        body = response.body.to_s
        body.strip == '' ? {}: JSON.parse(body, symbolize_names: true)
      else
        {}
      end

      if http_ok && data.key?(SUCCESS_KEY)
        SuccessResponse.new(response, data)
      else
        ErrorResponse.new(response, data)
      end
    end

    attr_reader :response, :data

    def initialize(response, data)
      @response, @data = response, data
    end

    def code
      response.code.to_i
    end

    def ok?
      true
    end

    def head
      @head ||= data.dig(top_level_key, :Head)
    end

    def body
      @body ||= (
        d = data.dig(top_level_key, :Body)
        d.is_a?(Hash) ? d : {}
      )
    end

    def request_action
      @request_action ||= head.fetch(:RequestAction)
    end

    def to_json
      JSON.pretty_generate(data)
    end

    private
    def top_level_key
      SUCCESS_KEY
    end
  end

  class SuccessResponse < Response
    def request_id
      @request_id ||= head.fetch(:RequestId)
    end

    def response_type
      @response_type ||= head.fetch(:ResponseType)
    end

    def timestamp
      @timestamp ||= Time.parse(head.fetch(:Timestamp))
    end
  end

  class ErrorResponse < Response

    def ok?
      false
    end

    def error_type
      @error_type ||= head.fetch(:ErrorType)
    end

    def error_code
      @error_code ||= head.fetch(:ErrorCode)
    end

    def error_message
      @error_message ||= head.fetch(:ErrorMessage)
    end

    private
    def top_level_key
      ERROR_KEY
    end
  end
end