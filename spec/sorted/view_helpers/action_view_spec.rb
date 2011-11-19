require 'spec_helper'
require 'action_controller'


describe Sorted::ViewHelpers::ActionView do
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
    
    def _prefixes
    end
  end
  class Request
    def get?; true end
  end

  ActionView::Base.send(:include, Sorted::ViewHelpers::ActionView)

  it "should integrate with ActionView::Base" do
    ActionView::Base.new.should respond_to(:link_to_sorted)
  end
end

describe Sorted::ViewHelpers::ActionView::Sorted do
  it "should not change the direction of name using view helper" do
    order  = :email
    params = { :page => 10 }
    result = { :page => 10, :sort => "email_asc" }

    sorter = Sorted::ViewHelpers::ActionView::Sorted.new order, params
    sorter.params.should eq result
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

describe Sorted::Parser, "to_css" do
  it "should return css base class for to_css if not in sort params" do
    sorter = Sorted::Sorter.new(:email)
    sorter.to_css.should == "sorted"
  end

  it "should return css class for to_css" do
    sorter = Sorted::Sorter.new(:email, {:sort => "email_desc"})
    sorter.to_css.should == "sorted desc"
  end
end
