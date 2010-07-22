require 'active_record'
require 'sorted'

module Sorted
  module ActiveRecord
    def self.enable!
      ::ActiveRecord::Base.class_eval do
        scope :sorted, lambda { |*args| Hash[:order, Sorter.new(args[0], args[1]).to_sql] }
      end
    end
  end
end
