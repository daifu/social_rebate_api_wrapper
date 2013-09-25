module SocialRebate
  class Connection
    include HTTParty

    base_uri "socialrebate.net"
    format   :json
    STATUS = ['UNVERIFIED', 'VERIFIED', 'VOID', 'COUPON']

    class ResponseError < StandardError; end

    def initialize(creds={})
      validate_creds(creds)

      @configuration = {}
      SocialRebate::Connection.api_token_keys.each do |key|
        @configuration[key]   = creds[key].to_s
      end
      @store_key              = creds[:store_key]
      @configuration[:format] = 'json'
    end

    def self.api_token_keys
      [:api_key, :api_secret].freeze
    end

    def self.api_required_keys
      [:api_key, :api_secret, :store_key].freeze
    end

    def validate_creds(creds)
      SocialRebate::Connection.api_required_keys.each do |key|
        raise ResponseError.new("Required key: #{key} missing") unless creds[key]
      end
    end

    def request(method, url, options={})
      unless api_token_keys_valid?
        raise ResponseError.new("Please set api_key and api_secret correctly")
      end
      options[:body] = options[:body].to_json if options[:body]
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
      check_post_url(url)
      body.merge!(@configuration).merge!({:store_key => @store_key})

      options = {}
      options[:body]    = body
      options[:headers] = set_headers(headers)
      request(:post, url, options)
    end

    def put(url, body={}, headers={})
      check_body_params(body)
      check_put_url(url)

      body    = body.merge!(@configuration).merge!({:store_key => @store_key})
      options = {}
      options[:body]    = body
      options[:headers] = set_headers(headers)
      request(:put, url, options)
    end

    def set_headers(headers)
      hash = {}
      hash = headers unless headers.empty?
      hash['content-type'] = "application/json"
      hash['Accept']       = "application/json"
      hash
    end

    def check_body_params(body)
      if !body.key?(:status) || !SocialRebate::Connection::STATUS.include?(body[:status])
        raise ResponseError.new("Missing or incorrect status param")
      end
    end

    def check_put_url(url)
      if url !~ /\/v[0-9]+\/orders\/[0-9a-zA-Z]+\/$/i
        raise ResponseError.new("Incorrect put request url, expected: /api/v[0-9]/orders/<your order id>/")
      end
    end

    def check_post_url(url)
      if url !~ /\/v[0-9]+\/orders\/$/i
        raise ResponseError.new("Incorrect post request url, expected: /api/v[0-9]/orders/")
      end
    end
  end
end
