require 'spec_helper'

describe SocialRebate::Connection do

  before :each do
    @sr = SocialRebate::Connection.new({:api_secret => "aec49293dce43e0cd0856adb28a2d05355ec2924", :api_key => "279d94e91d34216d97f56b00e97fa4ff8478f91e"})
  end

  context "GET" do
    describe "connection method" do
      it "should get last x orders for which social rebate has created a rebate" do
        @sr.get('/api/v2/orders/').should == {
          'meta' => {
            'limit'       => 20,
            'next'        => nil,
            'offset'      => 0,
            'previous'    => nil,
            'total_count' => 0
          },
          'objects'       => []
        }
      end
    end
  end

end
