require 'active_record'

module Sorted
  module ActiveRecord
    def self.enable!
      ::ActiveRecord::Base.class_eval do
        scope :sorted, lambda{|params|
          return if params.nil?
          order = []
          params.split(/,/).each do |param|
            order << param.gsub(/_asc/, ' ASC').gsub(/_desc/, ' DESC')
          end
          {:order => order.join(', ')}
        }
      end
    end
  end
end
