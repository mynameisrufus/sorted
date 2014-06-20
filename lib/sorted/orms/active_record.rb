require 'sorted'
require 'active_support/concern'

module Sorted
  module Orms
    module ActiveRecord
      extend ActiveSupport::Concern

      included do
        def self.sorted(sort, default_order = nil)
          order sort_sql(sort, default_order)
        end

        def self.sorted!(sort, default_order = nil)
          reorder sort_sql(sort, default_order)
        end

        private

        def self.sort_sql(sort, default_order)
          sorter(sort, default_order).to_sql(quoter)
        end

        def self.sorter(sort, default_order)
          ::Sorted::Parser.new(sort, default_order)
        end

        def self.quoter
          ->(frag) { connection.quote_column_name(frag) }
        end
      end
    end
  end
end
