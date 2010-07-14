require 'action_view'

module Sorted
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
