require 'spec_helper'

describe Sorted::Parser, "params parsing" do
  it "should not raise if pased nil arguments" do
    lambda { Sorted::Parser.new(nil, nil).toggle }.should_not raise_error
  end

  it "should return a nice array from the order sql" do
    sort   = nil
    order  = "email ASC, phone ASC, name DESC"
    result = [["email", "asc"], ["phone", "asc"], ["name", "desc"]]

    sorter = Sorted::Parser.new(sort, order)
    sorter.orders.should eq result
  end

  it "should return a nice array from the sort params" do
    sort   = "email_desc!name_desc"
    order  = nil
    result = [["email", "desc"], ["name", "desc"]]

    sorter = Sorted::Parser.new(sort, order)
    sorter.sorts.should eq result
  end

  it "should combine sort and order params with sort params being of higer importance" do
    sort   = "email_desc!name_desc"
    order  = "email ASC, phone ASC, name DESC"
    result = [["email", "desc"], ["name", "desc"], ["phone", "asc"]]

    sorter = Sorted::Parser.new(sort, order)
    sorter.to_a.should eq result
  end

  it "should allow numbers, underscores and full stops in sort params" do
    sort   = "assessmentsTable.name_desc!users_300.name_5_desc"
    order  = nil
    result = [["assessmentsTable.name", "desc"], ["users_300.name_5", "desc"]]

    sorter = Sorted::Parser.new(sort, order)
    sorter.sorts.should eq result
  end

  it "should allow numbers, underscores and full stops in order params" do
    sort   = nil
    order  = "assessmentsTable.name ASC, users_300.name_5 ASC"
    result = [["assessmentsTable.name", "asc"], ["users_300.name_5", "asc"]]

    sorter = Sorted::Parser.new(sort, order)
    sorter.orders.should eq result
  end

  it "should default to asc if sort params order is ommited" do
    sort   = nil
    order  = :email
    result = [["email", "asc"]]

    sorter = Sorted::Parser.new(sort, order)
    sorter.orders.should eq result
  end
end

describe Sorted::Parser, "return types" do
  it "should return an sql sort string" do
    sort   = "email_desc!name_desc"
    order  = "email ASC, phone ASC, name DESC"
    result = "email DESC, name DESC, phone ASC"

    sorter = Sorted::Parser.new(sort, order)
    sorter.to_sql.should eq result
  end

  it "should return an hash" do
    sort   = "email_desc!name_desc"
    order  = "email ASC, phone ASC, name DESC"
    result = {"email" => "desc", "name" => "desc", "phone" => "asc"}

    sorter = Sorted::Parser.new(sort, order)
    sorter.to_hash.should eq result
  end

  it "should return an the encoded sort string" do
    sort   = "email_desc!name_desc"
    order  = "email ASC, phone ASC, name DESC"
    result = "email_desc!name_desc!phone_asc"

    sorter = Sorted::Parser.new(sort, order)
    sorter.to_s.should eq result
  end
end
