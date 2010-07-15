require 'action_view'

module Sorted
  module ActionView
    def sorted_params(attribute)
      get_params = request.get? ? params.dup : {:order => nil}
      get_params[:order] = sorted_order(get_params[:order], attribute)
      get_params
    end

    def link_to_sorted(name, attribute, options = nil)
      @sorted_params = sorted_params(attribute)
      if options.nil?
        options = {:class => sorted_css_class}
      elsif options[:class].nil?
        options.merge(:class => sorted_css_class)
      else
        options[:class] = "#{options[:class]} #{sorted_css_class}"
      end
      link_to(name, @sorted_params.merge(:order => sorted_to_string), options)
    end

    protected

    def sorted_css_class
      "sorted-#{@sorted_params[:order].first[1]}"
    end

    def sorted_order(sort_string, attribute, order_rest = {})
      order_first = {attribute => 'asc'}
      if sort_string.class == String
        sort_string.split(/\|/).each do |order|
          order.match(/(\w+)_(asc|desc)/) do |match_data|
            if match_data[1] == attribute.to_s
              order_first = {attribute => sorted_sql_reverse(match_data[2])}
            else
              order_rest = order_rest.merge(match_data[1] => match_data[2])
            end
          end
        end
      end
      order_first.merge(order_rest).symbolize_keys
    end

    def sorted_to_string
      @sorted_params[:order].map do |order|
        order.join('_')
      end.join('|')
    end

    def sorted_sql_reverse(order)
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
