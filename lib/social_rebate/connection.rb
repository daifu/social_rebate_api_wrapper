module SocialRebate
  class Connection
    include HTTParty

    base_uri "http://socialrebate.net"
    format   :json

    class ResponseError < StandardError; end

    def initialize(creds={})
      @configuration = {}
      SocialRebate::Connection.api_token_keys.each do |key|
        @configuration[key] = creds[key].to_s
      end
    end

    def self.api_token_keys
      [:api_key, :api_secret].freeze
    end

    def request(method, url, options={})
      unless api_token_keys_valid?
        raise ResponseError.new("Please set username and password correctly")
      end
      url="#{url}&#{serialize_param(@configuration)}"
      parsed_response(self.class.__send__(method, url, options))
    end

    def parsed_response(response)
      if response.is_a? Net::HTTPResponse
        unless response.is_a? Net::HTTPSuccess
          raise ResponseError.new(response)
        end
        JSON.parse(response.body)
      else
        unless response.success?
          raise ResponseError.new(response)
        end
        response.parsed_response
      end
    end

    def api_token_keys_valid?
      return SocialRebate::Connection.api_token_keys.detect {|key| @configuration[key] == ''} == nil
    end

    def serialize_param(params)
      params.sort.map {|key, value| URI.escape("#{key}=#{value}")}.join('&')
    end

    def get(url, params={}, options={})
      url = "#{url}?format=json"
      unless params.empty?
        url = "#{url}&#{serialize_param(params)}"
      end
      request(:get, url, options)
    end

  end
end
