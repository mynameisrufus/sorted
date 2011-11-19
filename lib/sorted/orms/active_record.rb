require 'active_record'
require 'sorted'

module Sorted
  module Orms
    module ActiveRecord
      def self.enable!
        ::ActiveRecord::Base.class_eval do
          def self.sorted(sort, order = nil)
            sorter = ::Sorted::Parser.new(sort, order)
            order sorter.to_sql
          end
        end
      end
    end
  end
end
