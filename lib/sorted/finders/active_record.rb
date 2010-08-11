require 'active_record'
require 'sorted'

module Sorted
  module Finders
    module ActiveRecord
      def self.enable!
        ::ActiveRecord::Base.class_eval do
          scope :sorted, lambda { |params|
            params.merge(:order => ::Sorted::Sorter.new(params[:order], {:sort => params.delete(:sort)}).to_sql)
          }
        end
      end
    end
  end
end
