require 'spec_helper'

describe SocialRebate::Connection do
  before :each do
    @creds        = {:api_key => "your_api_key", :api_secret => "your_api_secret", :store_key => "your_store_key"}
    @sr           = SocialRebate::Connection.new(@creds)
    @creds_params = "api_key=your_api_key&api_secret=your_api_secret&format=json"
    @headers      = {'content-type' => 'application/json', 'Accept' => 'application/json'}
  end

  context "GET" do
    describe "connection method" do
      it "should get last x orders for which social rebate has created a rebate" do
        @sr.stub(:request).with(:get,"/api/v2/orders/?"+@creds_params+"&limit=20&offset=20")
        @sr.get("/api/v2/orders/", {:limit => 20, :offset => 20})
      end

      it "should raise exception with incorrect keys" do
        expect {
          @sr.get("/api/v2/orders/")
        }.to raise_error(SocialRebate::Connection::ResponseError)
      end
    end
  end

  context "POST" do
    describe "creating orders" do
      before :each do
        @body = {:order_email => 'test@fip.com', :total_purchase => 10, :order_id => 1}
      end
      it "should create an order" do
        @sr.stub(:request).with(:post, "/api/v2/orders/", {:body => @body.merge(@creds).merge(:format => 'json'), :headers => @headers})
        @sr.post("/api/v2/orders/", @body)
      end

      it "should raise exception with incorrect keys" do
        expect {
          @sr.post('/api/v2/orders/', @body)
        }.to raise_error(SocialRebate::Connection::ResponseError)
      end
    end
  end

  context "PUT" do
    describe "updating orders" do
      before :each do
        @body = {:status => "VOID", :order_email => 'test@fip.com', :total_purchase => '30.0', :order_id => 1}
      end

      it "should update an order" do
        @sr.stub(:request).with(:put, "/api/v2/orders/token/", {:body => @body.merge(@creds).merge(:format => 'json'), :headers => @headers})
        @sr.put("/api/v2/orders/token/", @body)
      end

      it "should raise exception with incorrect keys" do
        expect {
          @sr.put("/api/v2/orders/token/", @body)
        }.to raise_error(SocialRebate::Connection::ResponseError)
      end

      it "should raise exception if status is not correct" do
        @body[:status] = "not_valid"
        expect {
          @sr.put("/api/v2/orders/token/", @body)
        }.to raise_error(SocialRebate::Connection::ResponseError)
      end

      it "should raise exception if url is incorrect" do
        expect {
          @sr.put("/api/v2/orders/", @body)
        }.to raise_error(SocialRebate::Connection::ResponseError)
      end
    end
  end

end
