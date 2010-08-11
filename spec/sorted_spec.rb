require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'action_controller'
require 'sorted'

describe Sorted::Sorter, "parse methods" do
  it "should return a nice array from the order sql" do
    sorter = Sorted::Sorter.new("email ASC, phone ASC, name DESC", {:sort => "email_desc!name_desc"})
    sorter.orders.should == [["email", "asc"], ["phone", "asc"], ["name", "desc"]]
  end

  it "should return a nice array from the sort params" do
    sorter = Sorted::Sorter.new("email ASC, phone ASC, name DESC", {:sort => "email_desc!name_desc"})
    sorter.sorts.should == [["email", "desc"], ["name", "desc"]]
  end

  it "should allow underscores, full stops and colons in" do
    sorter = Sorted::Sorter.new('users.email ASC, users.phone_number DESC, assessments.name ASC, assessments.number_as_string::BigInt', {:sort => "users.email_desc!users.first_name_desc"})
    sorter.to_sql.should == "users.email DESC, users.first_name DESC, users.phone_number DESC, assessments.name ASC, assessments.number_as_string::BigInt ASC"
  end
end

describe Sorted::Sorter, "logic:" do
  it "should not toggle the sort order and include any sql orders not in sort params" do
    sorter = Sorted::Sorter.new("email ASC, phone ASC, name DESC", {:sort => "email_desc!name_desc"})
    sorter.to_a.should == [["email", "desc"], ["name", "desc"], ["phone", "asc"]]
  end

  it "should toggle the sort order and include any sql orders not in sort params" do
    sorter = Sorted::Sorter.new("email DESC, phone ASC, name DESC", {:sort => "email_desc!name_desc"})
    sorter.toggle.to_a.should == [["email", "desc"], ["name", "desc"], ["phone", "asc"]]
  end

  it "should toggle the sort order and include any sql orders not in sort params" do
    sorter = Sorted::Sorter.new("email DESC, phone ASC, name DESC", {:sort => "mobile_asc!email_desc!phone_asc!name_desc"})
    sorter.toggle.to_a.should == [["email", "desc"], ["phone", "asc"], ["name", "desc"], ["mobile", "asc"]]
  end

  it "should return an sql sort string" do
    Sorted::Sorter.new(:email).to_sql.should == "email ASC"
    Sorted::Sorter.new(:email, {:sort => "name_desc!email_desc"}).to_sql.should == "name DESC, email DESC"
  end

  it "should handle a large initial order string" do
    sorter = Sorted::Sorter.new('email ASC, name DESC, phone ASC', {:sort => "email_desc!name_desc"})
    sorter.to_sql.should == "email DESC, name DESC, phone ASC"
  end

  it "should handle a large initial order string" do
    sorter = Sorted::Sorter.new('email ASC, phone DESC, name ASC', {:sort => "email_desc!name_desc"})
    sorter.to_sql.should == "email DESC, name DESC, phone DESC"
  end

  it "should should fail becasue the sort order is incorect" do
    sorter = Sorted::Sorter.new(:jsci_complete, {:sort => "parent_id_desc!non_vocational_complete_desc!jsci_complete_desc"})
    sorter.toggle
    sorter.to_s.should_not == "parent_id_desc!non_vocational_complete_desc!jsci_complete_desc"
  end

  it "should return css base class for to_css if not in sort params" do
    sorter = Sorted::Sorter.new(:email)
    sorter.toggle
    sorter.to_css.should == "sorted"
  end

  it "should return css class for to_css" do
    sorter = Sorted::Sorter.new(:email, {:sort => "email_desc"})
    sorter.toggle
    sorter.to_css.should == "sorted desc"
  end

  it "should toggle two order params at once" do
    first = Sorted::Sorter.new("email ASC, phone ASC")
    first.toggle.to_a.should == [["email", "asc"],["phone", "asc"]]
    second = Sorted::Sorter.new(:name, {:sort => first.to_s})
    second.toggle.to_a.should == [["name", "asc"], ["email", "asc"],["phone", "asc"]]
    third = Sorted::Sorter.new("email ASC, phone ASC", {:sort => second.to_s})
    third.toggle.to_a.should == [["email", "asc"],["phone", "asc"], ["name", "asc"]]
  end
end

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
