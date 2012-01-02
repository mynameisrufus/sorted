require 'active_record'
require 'sorted'

module Sorted
  module Orms
    module ActiveRecord
      def self.included(base)
        def base.sorted(sort, default_order = nil)
          sorter = ::Sorted::Parser.new(sort, default_order)
          order sorter.to_sql
        end
      end
    end
  end
end
