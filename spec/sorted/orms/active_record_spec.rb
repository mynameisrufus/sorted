require 'spec_helper'
require 'active_record'

describe Sorted::Orms::ActiveRecord do
  before(:each) do
    Sorted::Orms::ActiveRecord.enable!
  end

  it "should integrate with ActiveRecord::Base" do
    ActiveRecord::Base.should respond_to(:sorted)
  end
end
