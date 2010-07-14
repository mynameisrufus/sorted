require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

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
    ActionView::Base.new.should respond_to(:sorted)
  end

  it "should return a hash for url" do
    ActionView::Base.new([], {}, @controller).sorted(:email).should == {:order=>"email_asc", :page=>nil, :per_page=>nil}
  end
end
