require 'action_view'

module Sorted
  module ActionView
    def sorted_hash(attribute, order_rest = {})
      request.get? ? get_params = params.dup : return
      order_first = {attribute => 'asc'}
      if get_params[:order].present?
        get_params[:order].split(/,/).each do |param|
          param.match(/(\w+)_(asc|desc)/) do |match_data|
            if match_data[1] == attribute.to_s
              order_first = {attribute => sql_reverse_for_sorted(match_data[2])}
            else
              order_rest = order_rest.merge( {match_data[1] => match_data[2]} )
            end
          end
        end
      end
      get_params[:order] = order_first.merge(order_rest).symbolize_keys
      get_params
    end

    def link_to_sorted(name, attribute, options = nil)
      url_hash = sorted_hash(attribute)
      url_hash[:order] = url_hash[:order].map{|o|o.join('_')}.join(',')
      link_to(name, url_hash, {:class => url_hash[:order].first[1]})
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
