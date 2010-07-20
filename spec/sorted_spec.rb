require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'action_controller'

describe Sorted::ActiveRecord do
  before(:each) do
    Sorted::ActiveRecord.enable!
  end

  it "should integrate with ActiveRecord::Base" do
    ActiveRecord::Base.should respond_to(:sorted)
  end
end

describe Sorted::ActionView do
  before(:each) do
    class TestController
      def params
        @params ||= {}
      end

      def params=(params)
        @params = params
      end

      def request
        Request.new
      end
    end
    class Request
      def get?; true end
    end
    @controller = TestController.new
    ActionView::Base.send(:include, Sorted::ActionView)
  end
  
  it "should integrate with ActionView::Base" do
    ActionView::Base.new.should respond_to(:sorted)
  end

  it "should not change the direction of name" do
    @controller.params = {:order => "name_desc"}
    ActionView::Base.new([], {}, @controller).sorted(:email).to_hash.should == {:email => "asc", :name => "desc"}
  end

  it "should reverse email direction" do
    @controller.params = {:order => "email_asc!name_desc"}
    ActionView::Base.new([], {}, @controller).sorted(:email).to_hash.should == {:email => "desc", :name => "desc"}
  end

  it "should return a hash of options for url builder with sorted query string" do
    @controller.params = {:order => "email_asc!name_desc", :page => 2}
    ActionView::Base.new([], {}, @controller).sorted(:email).params.should == {:order => "email_desc!name_desc", :page => 2}
  end

  it "should not die if params nil" do
    sorter = ActionView::Base.new([], {}, @controller).sorted(:email)
    sorter.params.should == {:order => "email_asc"}
  end

  it "should have some roll your own methods" do
    sorter = ActionView::Base.new([], {}, @controller).sorted(:email)
    sorter.other_attributes.should == {}
    sorter.to_s.should             == "email_asc"
    sorter.current_order.should    == "asc"
  end
end
