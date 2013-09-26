require 'spec_helper'

describe SocialRebate do
  before :each do
    @creds = {}
    @creds[:api_key]    = SocialRebate::Config.api_key
    @creds[:api_secret] = SocialRebate::Config.api_secret
    @creds[:store_key]  = SocialRebate::Config.store_key
    @cn = SocialRebate::Connection.new(@creds)
    SocialRebate::Connection.stub(:new).with(@creds).and_return(@cn)
    @token  = 'token'
    @option = {:order_email => 'email', :total_purchase => '10', :order_id => 1000}
  end

  describe "verify" do
    it "should receive correct params for put request" do
      @option[:status] = "VERIFIED"
      @cn.stub(:put).with("/api/v2/orders/#{@token}/", @option)
      SocialRebate.verify(@token, @option)
    end
  end

  describe "cancel" do
    it "should receive correct params for cancel request" do
      @option[:status] = "VOID"
      @cn.stub(:put).with("/api/v2/orders/#{@token}/", @option)
      SocialRebate.verify(@token, @option)
    end
  end

  describe "init_social_rebate_session" do
    it "should receive correct params for social rebate request" do
      @cn.stub(:post).with("/api/v2/orders/", @option)
      SocialRebate.init_social_rebate_session(@option)
    end
  end

end
