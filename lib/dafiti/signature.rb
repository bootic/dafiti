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

    # documentation about arrays: 
    # Can either be a JSON array (e.g., [“E213”,”KI21”,”HT0”]) 
    # or a serialized PHP array (e.g., a:3:{i:0;s:4:”E213”;i:1;s:4:”KI21”;i:2;s:3:”HT0”;}).
    def encoded
      @encoded ||= params.map {|k, v|
        val = v.is_a?(Array) ? v.to_json : v.to_s
        "#{CGI.escape(k.to_s)}=#{CGI.escape(val)}"
      }.join('&')
    end
  end
end
