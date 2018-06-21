require 'time'
require 'cgi'
require 'openssl'

module Dafiti
  class Signature
    API_VERSION = '1.0'.freeze

    def self.generate_query(api_key:, user_id:, params: {})
      new(api_key, user_id).query(params)
    end

    def self.signature(api_key:, user_id:, params: {})
      new(api_key, user_id).signature(params)
    end

    def initialize(api_key, user_id)
      @api_key, @user_id = api_key, user_id
    end

    def query(params)
      now = Time.now.iso8601
      base = {
        'UserID' => user_id,
        'Version' => API_VERSION,
        'Timestamp' => now
      }
      params = base.merge(params).sort.to_h # sorted by keys
      encoded = params.map {|k, v|
        "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}"
      }.join('&')

      sign = OpenSSL::HMAC.hexdigest('SHA256', api_key, encoded)
      [encoded, "Signature=#{CGI.escape(sign)}"].join('&')
    end

    def signature(params)
      now = Time.now.iso8601
      base = {
        'UserID' => user_id,
        'Version' => API_VERSION,
        'Timestamp' => now
      }
      params = base.merge(params).sort.to_h # sorted by keys
      encoded = params.map {|k, v|
        "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}"
      }.join('&')

      CGI.escape OpenSSL::HMAC.hexdigest('SHA256', api_key, encoded)
    end

    private
    attr_reader :api_key, :user_id
  end
end
