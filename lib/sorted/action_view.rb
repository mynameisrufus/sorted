require 'action_view'

module Sorted
  module ActionView
    def sorted_hash(attribute, order_rest = [])
      order_first = {attribute.to_sym => 'asc'}
      if params[:order].present? && order_rest.empty?
        params[:order].split(/,/).each do |param|
          param.match(/(\w+)_(asc|desc)/) do |match_data|
            if match_data[1] == attribute.to_s
              order_first = {attribute.to_sym => sql_reverse_for_sorted(match_data[2])}
            else
              order_rest << {match_data[1].to_sym => match_data[2]}
            end
          end
        end
      end
      order_rest.unshift(order_first)
    end

    def link_to_sorted(name, attribute, options = nil)
      url_hash = sorted(attribute)
      link_to(name, sorted_to_s(url_hash), {:class => url_hash.first.first[1]})
    end

    def sorted_to_s(url_hash)
      url_hash.map do |h|
        h.first.join('_')
      end.join(',')
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
