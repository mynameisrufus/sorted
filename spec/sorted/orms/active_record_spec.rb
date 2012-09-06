require 'spec_helper'

describe Sorted::Orms::ActiveRecord do
  ActiveRecord::Base.send(:include, Sorted::Orms::ActiveRecord)
  
  class SortedActiveRecordTest < ActiveRecord::Base
    establish_connection :adapter => 'sqlite3', :database => ':memory:'

    connection.create_table table_name, :force => true do |t|
      t.string :name
    end

    scope :page, lambda {
      limit(50)
    }
  end

  it "should integrate with ActiveRecord::Base" do
    SortedActiveRecordTest.should respond_to(:sorted)
  end

  it "should play nice with other scopes" do
    sql = "SELECT  \"sorted_active_record_tests\".* FROM \"sorted_active_record_tests\"  WHERE \"sorted_active_record_tests\".\"name\" = 'bob' ORDER BY name ASC LIMIT 50"
    SortedActiveRecordTest.where(:name => 'bob').page.sorted(nil, 'name ASC').to_sql.should == sql
    SortedActiveRecordTest.page.sorted(nil, 'name ASC').where(:name => 'bob').to_sql.should == sql
  end
end
