require 'active_record'
require 'sorted'
require 'active_support/concern'

module Sorted
  module Orms
    module ActiveRecord
      extend ActiveSupport::Concern

      included do
        def self.sorted(sort, default_order = nil)
          sorter = ::Sorted::Parser.new(sort, default_order)
          quoter = ->(frag) { connection.quote_column_name(frag) }
          order sorter.to_sql(quoter)
        end
      end
    end
  end
end
