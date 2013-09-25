module SocialRebate
  class Connection
    include HTTParty

    base_uri "socialrebate.net"
    format   :json
    STATUS = ['required', 'VERIFIED', 'VOID', 'COUPON']

    class ResponseError < StandardError; end

    def initialize(creds={})
      @configuration = {}
      SocialRebate::Connection.api_token_keys.each do |key|
        @configuration[key]   = creds[key].to_s
      end
      @configuration[:format] = 'json'
    end

    def self.api_token_keys
      [:api_key, :api_secret, :store_key].freeze
    end

    def request(method, url, options={})
      unless api_token_keys_valid?
        raise ResponseError.new("Please set api_key and api_secret correctly")
      end
      parsed_response(self.class.__send__(method, url, options))
    end

    def parsed_response(response)
      unless response.success?
        raise ResponseError.new(response)
      end
      response.parsed_response
    end

    def api_token_keys_valid?
      return SocialRebate::Connection.api_token_keys.detect {|key| @configuration[key] == ''} == nil
    end

    def serialize_param(params)
      params.sort.map {|key, value| URI.escape("#{key}=#{value}")}.join('&')
    end

    def get(url, params={})
      url   = "#{url}?#{serialize_param(@configuration)}"
      unless params.empty?
        url = "#{url}&#{serialize_param(params)}"
      end
      request(:get, url)
    end

    def post(url, body={}, headers={})
      body    = body.merge!(@configuration)
      options = {}
      options[:body]                    = body.to_json
      options[:headers]                 = headers
      options[:headers]['content-type'] = "application/json"
      options[:headers]['Accept']       = "application/json"
      request(:post, url, options)
    end

    def put(url, body={}, headers={})
      check_body_params(body)

      body    = body.merge!(@configuration)
      options = {}
      options[:body]                    = body.to_json
      options[:headers]                 = headers
      options[:headers]['content-type'] = "application/json"
      options[:headers]['Accept']       = "application/json"
      request(:put, url, options)
    end

    def check_body_params(body)
      if !body.key?(:status) || !SocialRebate::Connection::STATUS.include?(body[:status])
        raise ResponseError.new("Missing or incorrect status param")
      end
    end
  end
end
