require 'active_record'
require 'sorted'

module Sorted
  module ActiveRecord
    def self.enable!
      ::ActiveRecord::Base.class_eval do
        scope :sorted, lambda { |params| Hash[:order, ::Sorted::Sorter.new(params[:order], {:sort => params[:sort]}).to_sql] }
      end
    end
  end
end
