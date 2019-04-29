require 'time'
require 'cgi'
require 'openssl'

# https://sellerapi.sellercenter.net/docs/signing-requests
module Dafiti
  class Signature
    API_VERSION = '1.0'.freeze

    attr_reader :params

    def initialize(api_key:, user_id:, params: {})
      @api_key, @user_id = api_key, user_id
      base = {
        'UserID' => user_id,
        'Version' => API_VERSION,
        'Timestamp' => Time.now.iso8601
      }
      @params = base.merge(params).sort.to_h
    end

    def signature
      @signature ||= CGI.escape OpenSSL::HMAC.hexdigest('SHA256', api_key, encoded)
    end

    def query_string
      [encoded, "Signature=#{signature}"].join('&')
    end

    private
    attr_reader :api_key, :user_id

    def encoded
      @encoded ||= params.map {|k, v|
        "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}"
      }.join('&')
    end
  end
end
