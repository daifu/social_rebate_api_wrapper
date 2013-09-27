require 'spec_helper'

describe SocialRebate do
  before :each do
    @creds = {}
    @creds[:api_key]    = SocialRebate::Config.api_key
    @creds[:api_secret] = SocialRebate::Config.api_secret
    @creds[:store_key]  = SocialRebate::Config.store_key
    @cn = {}
    SocialRebate::Connection.stub(:new).with(@creds).and_return(@cn)
    @token  = 'token'
    @option = {:order_email => 'email', :total_purchase => '10', :order_id => 1000}
  end

  describe "verify" do
    it "should receive correct params for put request" do
      @option[:status] = "VERIFIED"
      @cn.should_receive(:put).with("/api/v2/orders/#{@token}/", @option)
      SocialRebate.verify(@token, @option)
    end
  end

  describe "cancel" do
    it "should receive correct params for cancel request" do
      @option[:status] = "VOID"
      @cn.should_receive(:put).with("/api/v2/orders/#{@token}/", @option)
      SocialRebate.cancel(@token, @option)
    end
  end

  describe "init" do
    it "should receive correct params for social rebate request" do
      @cn.should_receive(:post).with("/api/v2/orders/", @option)
      SocialRebate.init(@option)
    end
  end

end
