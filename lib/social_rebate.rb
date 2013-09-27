require "social_rebate/version"
require "httparty"
require "json"
require "uri"
require "social_rebate/config"
require "social_rebate/connection"

module SocialRebate

  def self.verify(token, option={})
    set_status(token, option, 'VERIFIED')
  end

  def self.cancel(token, option={})
    set_status(token, option, 'VOID')
  end

  def self.coupon(token, option={})
    set_status(token, option, "COUPON")
  end

  def self.set_status(token, option, status)
    return unless is_enabled?
    option[:status] ||= status
    SocialRebate::Connection.new(creds).put("#{sub_base_uri}#{token}/", option)
  end

  def self.init(option={})
    return unless is_enabled?
    SocialRebate::Connection.new(creds).post(sub_base_uri, option)
  end

  def self.get(option={}, url='/api/v2/orders/')
    return unless is_enabled?
    SocialRebate::Connection.new(creds).get(url, option)
  end

  def self.creds
    creds = {}
    creds[:api_key]    ||= Config.api_key
    creds[:api_secret] ||= Config.api_secret
    creds[:store_key]  ||= Config.store_key
    creds
  end

  def self.sub_base_uri
    "/api/#{Config.api_version}/orders/"
  end

  def self.is_enabled?
    Config.enabled?
  end

end
