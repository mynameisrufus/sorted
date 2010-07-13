require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Sorted::ActiveRecord do
  it "should integrate with ActiveRecord::Base" do
    ActiveRecord::Base.should respond_to(:sorted)
  end
end

describe Sorted::ActionView do
  before(:each) do
  end
  
  it "should integrate with ActionView::Base" do
    ActionView::Base.new.should respond_to(:sorted)
  end

  it "should return a hash for url" do
    sorted(:email).should be Hash
  end
end
