require 'active_record'
require 'sorted'

module Sorted
  module Finders
    module ActiveRecord
      def self.enable!
        ::ActiveRecord::Base.class_eval do
          # Define a symbolic sort column. This allows mapping a simple column name
          # to a more complex sql order clause.
          #  class Model < ActiveRecord::Base
          #    symbolic_sort :ip_address, 'inet_aton(`ip_address`)'
          #  end
          def self.symbolic_sort(key, sql)
            symbolic_sorts[key] = sql
          end

          def self.sorted(params)
            sorter = ::Sorted::Sorter.new(params[:order], :sort => params[:sort], :symbolic_sorts => symbolic_sorts)
            # Check if we parsed some relationship includes and apply them
            # before applying the order
            relation = self
            if sorter.includes.size > 0
              # Remove self.name from includes
              my_name = self.name.to_sym
              real_includes = sorter.includes.delete_if{|include_name| include_name == my_name}
              relation = includes(real_includes) if real_includes.size > 0
            end
            relation.order(sorter.to_sql)
          end

          private

          def self.symbolic_sorts
            @symbolic_sorts ||= {}
          end
        end
      end
    end
  end
end
