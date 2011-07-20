require 'active_record'
require 'sorted'

module Sorted
  module Finders
    module ActiveRecord
      def self.enable!
        ::ActiveRecord::Base.class_eval do
          def self.sorted(params)
            sorter = ::Sorted::Sorter.new(params[:order], :sort => params[:sort])
            # Check if we parsed some relationship includes and apply them
            # before applying the order
            relation = self
            if sorter.includes.size > 0
              # Remove self.name from includes
              my_name = self.name.to_sym
              real_includes = sorter.includes.remove_if{|include_name| include_name == my_name}
              relation = includes(real_includes) if real_includes.size > 0
            end
            relation.order(sorter.to_sql)
          end
        end
      end
    end
  end
end
