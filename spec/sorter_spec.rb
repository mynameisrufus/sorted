require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'action_controller'
require 'sorted'

describe Sorted::Sorter, "parse methods" do
  it "should not die if pased dumb things" do
    lambda { Sorted::Sorter.new(false, Time.now).should_not }.should_not raise_error
  end

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
end

describe Sorted::Sorter, "to_css" do
  it "should return css base class for to_css if not in sort params" do
    sorter = Sorted::Sorter.new(:email)
    sorter.to_css.should == "sorted"
  end

  it "should return css class for to_css" do
    sorter = Sorted::Sorter.new(:email, {:sort => "email_desc"})
    sorter.to_css.should == "sorted desc"
  end
end
