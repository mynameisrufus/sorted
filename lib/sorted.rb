require 'active_record'
require 'action_view'

module Sorted
  module ActiveRecord
    def self.enable!
      ::ActiveRecord::Base.class_eval do
        scope :sorted, lambda{|params|
          return if params.nil?
          order = []
          params.split(/\|/).each do |param|
            order << param.gsub(/_asc/, ' ASC').gsub(/_desc/, ' DESC')
          end
          {:order => order.join(' ,')}
        }
      end
    end
  end

  module ActionView
    def self.enable!
      ::ActionView::Base.send(:include, ActionView)
    end

    module ActionView
      def sorted(attribute)
        order_first = "#{attribute.to_s}_asc"
        order_rest  = []
        if params[:order].present?
          params[:order].split(/\|/).each do |param|
            param.match(/(\w+)_(asc|desc)/) do |match_data|
              if match_data[1] == attribute.to_s
                order_first = "#{attribute.to_s}_#{sql_reverse_for_sorted(match_data[2])}"
              else
                order_rest << param
              end
            end
          end
        end
        {:order => order_rest.unshift(order_first).join('|'), :page => params[:page], :per_page => params[:per_page]}
      end
      
      def sql_reverse_for_sorted(order)
        case order
        when 'asc'
          'desc'
        when 'desc'
          'asc'
        else
          'asc'
        end
      end
    end
  end
end

if defined? ::ActiveRecord and defined? ::ActionView
  Sorted::ActiveRecord.enable!
  Sorted::ActionView.enable!
end
