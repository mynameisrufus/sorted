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
    end
    @controller = TestController.new
    ActionView::Base.send(:include, Sorted::ActionView)
  end
  
  it "should integrate with ActionView::Base" do
    ActionView::Base.new.should respond_to(:sorted_hash)
  end

  it "should return a hash for url" do
    @controller.params = {:order => "name_desc"}
    ActionView::Base.new([], {}, @controller).sorted_hash(:email).should == [{:email => "asc"}, {:name => "desc"}]
  end

  it "should return a hash for url" do
    @controller.params = {:order => "email_asc,name_desc"}
    ActionView::Base.new([], {}, @controller).sorted_hash(:email).should == [{:email => "desc"}, {:name => "desc"}]
  end

  it "should return a query string for link options" do
    @controller.params = {:order => "email_asc,name_desc"}
    url_hash = ActionView::Base.new([], {}, @controller).sorted_hash(:email)
    ActionView::Base.new([], {}, @controller).sorted_to_s(url_hash).should == "email_desc,name_desc"
  end
end
