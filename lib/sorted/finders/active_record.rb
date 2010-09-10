require 'active_record'
require 'sorted'

module Sorted
  module Finders
    module ActiveRecord
      def self.enable!
        ::ActiveRecord::Base.class_eval do
          def self.sorted(params)
            order(::Sorted::Sorter.new(params[:order], :sort => params[:sort]).to_sql)
          end
        end
      end
    end
  end
end
