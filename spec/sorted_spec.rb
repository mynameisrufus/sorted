require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'action_controller'
require 'sorted'

describe Sorted::Finders::ActiveRecord do
  before(:each) do
    Sorted::Finders::ActiveRecord.enable!
  end

  it "should integrate with ActiveRecord::Base" do
    ActiveRecord::Base.should respond_to(:sorted)
  end
end

describe Sorted::ViewHelpers::ActionView do
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
    ActionView::Base.send(:include, Sorted::ViewHelpers::ActionView)
  end
  
  it "should integrate with ActionView::Base" do
    ActionView::Base.new.should respond_to(:sorted)
  end

  it "should integrate with ActionView::Base" do
    ActionView::Base.new.should respond_to(:link_to_sorted)
  end

  it "should not change the direction of name using view helper" do
    @controller.params = {:sort => "name_desc!email_asc"}
    sorter = ActionView::Base.new([], {}, @controller).sorted(:email)
    sorter.toggle.to_a.should == [["email", "asc"], ["name", "desc"]]
  end

  it "should reverse email direction using view helper" do
    @controller.params = {:sort => "email_asc!name_desc"}
    sorter = ActionView::Base.new([], {}, @controller).sorted(:email)
    sorter.toggle.to_a.should == [["email", "desc"], ["name", "desc"]]
  end

  it "should reverse email direction using view helper" do
    @controller.params = {:sort => "email_desc!name_desc!phone_desc"}
    sorter = ActionView::Base.new([], {}, @controller).sorted(:email)
    sorter.toggle.params.should == {:sort => "email_asc!name_desc!phone_desc"}
    @controller.params = sorter.params
    sorter = ActionView::Base.new([], {}, @controller).sorted(:email)
    sorter.toggle.params.should == {:sort => "email_desc!name_desc!phone_desc"}
  end

  it "should not reverse order when made first again" do
    @controller.params = {:sort => "phone_desc!name_desc!email_desc"}
    sorter = ActionView::Base.new([], {}, @controller).sorted(:email)
    sorter.toggle.params.should == {:sort => "email_desc!phone_desc!name_desc"}
    sorter = ActionView::Base.new([], {}, @controller).sorted(:name)
    sorter.toggle.params.should == {:sort => "name_desc!phone_desc!email_desc"}
  end

  it "should order correctly" do
    sorter = ActionView::Base.new([], {}, @controller).sorted(:email)
    sorter.toggle.params.should == {:sort => "email_asc"}
    @controller.params = sorter.params
    sorter = ActionView::Base.new([], {}, @controller).sorted(:name)
    sorter.toggle.params.should == {:sort => "name_asc!email_asc"}
  end

  it "should return a hash of options for url builder with sorted query string" do
    @controller.params = {:sort => "email_asc!name_desc", :page => 2}
    ActionView::Base.new([], {}, @controller).sorted(:email).params.should == {:sort => "email_desc!name_desc", :page => 2}
  end

  it "should not die if params nil" do
    sorter = ActionView::Base.new([], {}, @controller).sorted(:email)
    sorter.params.should == {:sort => "email_asc"}
  end
end
