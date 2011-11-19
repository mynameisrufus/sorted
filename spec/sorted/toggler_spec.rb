require 'spec_helper'

describe Sorted::Toggler do
  it "should bring phone to first order importance but not toggle ascendance" do
    orders = [["email", "asc"], ["phone", "asc"]]
    sorts  = [["phone", "asc"]]
    result = [["phone", "asc"], ["email", "asc"]]

    toggler = Sorted::Toggler.new(orders, sorts)
    toggler.to_a.should eq result
  end

  it "should toggle ascendance of email" do
    orders = [["email", "asc"], ["phone", "asc"]]
    sorts  = [["email", "asc"]]
    result = [["email", "desc"], ["phone", "asc"]]

    toggler = Sorted::Toggler.new(orders, sorts)
    toggler.to_a.should eq result
  end

  it "should return both order params un-toggled with no sort param" do
    orders = [["email", "asc"], ["phone", "asc"]]
    sorts  = []
    result = [["email", "asc"], ["phone", "asc"]]

    toggler = Sorted::Toggler.new(orders, sorts)
    toggler.to_a.should eq result
  end

  it "should toggle the email ascendance" do
    orders = [["email", "asc"]]
    sorts  = [["email", "asc"], ["phone", "asc"]]
    result = [["email", "desc"], ["phone", "asc"]]

    toggler = Sorted::Toggler.new(orders, sorts)
    toggler.to_a.should eq result
  end

  it "should toggle the email ascendance" do
    orders = [["email", "desc"]]
    sorts  = [["email", "asc"], ["phone", "asc"]]
    result = [["email", "desc"], ["phone", "asc"]]

    toggler = Sorted::Toggler.new(orders, sorts)
    toggler.to_a.should eq result
  end
end
