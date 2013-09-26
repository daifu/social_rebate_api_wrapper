require "social_rebate/version"
require "httparty"
require "json"
require "uri"
require "social_rebate/config"
require "social_rebate/connection"

module SocialRebate

  def self.verify(token, option={})
    option[:status] ||= 'VERIFIED'
    SocialRebate::Connection.new(creds).put("/api/v2/orders/#{token}/", option)
  end

  def self.cancel(token, option={})
    option[:status] ||= 'VOID'
    SocialRebate::Connection.new(creds).put("/api/v2/orders/#{token}", option)
  end

  def self.init_social_rebate_session(option={})
    SocialRebate::Connection.new(creds).post('/api/v2/orders/', option)
  end

  def self.get(option={})
    SocialRebate::Connection.new(creds).get(option)
  end

  def self.creds
    creds = {}
    creds[:api_key]    ||= Config.api_key
    creds[:api_secret] ||= Config.api_secret
    creds[:store_key]  ||= Config.store_key
    creds
  end

end
