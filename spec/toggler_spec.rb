require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'action_controller'
require 'sorted'

describe Sorted::Toggler, "toggle sorts" do
  it "should should fail becasue the sort order is incorect" do
    sorter = Sorted::Sorter.new(:jsci_complete, {:sort => "parent_id_desc!non_vocational_complete_desc!jsci_complete_desc"})
    sorter.toggle
    sorter.to_s.should_not == "parent_id_desc!non_vocational_complete_desc!jsci_complete_desc"
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

describe Sorted::Toggler, "add remaining orders" do
  it "should toggle the sort order and include any sql orders not in sort params" do
    sorter = Sorted::Sorter.new("email DESC, phone ASC, name DESC", {:sort => "email_desc!name_desc"})
    sorter.toggle.to_a.should == [["email", "desc"], ["name", "desc"], ["phone", "asc"]]
  end

  it "should toggle the sort order and include any sql orders not in sort params" do
    sorter = Sorted::Sorter.new("email DESC, phone ASC, name DESC", {:sort => "mobile_asc!email_desc!phone_asc!name_desc"})
    sorter.toggle.to_a.should == [["email", "desc"], ["phone", "asc"], ["name", "desc"], ["mobile", "asc"]]
  end
end

describe Sorted::Toggler, "add remaining sorts" do
  it "should toggle the sort order and include any sort orders not in order params" do
    sorter = Sorted::Sorter.new("email DESC", {:sort => "email_desc!name_desc"})
    sorter.toggle.to_a.should == [["email", "asc"], ["name", "desc"]]
  end
end
