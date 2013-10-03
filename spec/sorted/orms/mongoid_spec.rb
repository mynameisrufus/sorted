require 'spec_helper'

Mongoid.configure do |config|
  config.sessions = {:default => {:hosts => ['localhost:27017'], :database => 'kaminari_test'}}
end

describe Sorted::Orms::Mongoid do
  ::Mongoid::Criteria.send :include, Sorted::Orms::Mongoid
  ::Mongoid::Document.send :include, Sorted::Orms::Mongoid
  
  class SortedMongoidTest
    include ::Mongoid::Document

    field :name, :type => String

    def self.page
      limit(50)
    end
  end

  it "should integrate with Mongoid::Document" do
    SortedMongoidTest.should respond_to(:sorted)
  end

  it "should integrate with Mongoid::Criteria" do
    SortedMongoidTest.page.should respond_to(:sorted)
  end

  it "should play nice with other scopes" do
    query_options = {:limit=>50, :sort=>{"name"=>1}}
    SortedMongoidTest.page.sorted(nil, 'name ASC').options.should == query_options
    
    SortedMongoidTest.page.sorted(nil, 'name ASC').options.should == query_options
  end
end
