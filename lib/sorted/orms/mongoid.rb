# encoding: UTF-8
module Sorted
  module Orms
    module Mongoid
      extend ::ActiveSupport::Concern

      included do
      end

      module ClassMethods
        def sorted(sort, default_order = nil)
          sorter = ::Sorted::Parser.new(sort, default_order)
          order_by sorter.to_sql
        end
      end
    end
  end
end
