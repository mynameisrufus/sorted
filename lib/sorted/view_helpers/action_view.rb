require 'action_view'
require 'sorted'

module Sorted
  module ViewHelpers
    module ActionView
      class Sorted
        attr_reader :params

        def initialize(order, params)
          sort = params.delete :sort
          @order = order
          @params = params
          @parser = ::Sorted::Parser.new(sort, order).toggle
          @params[:sort] = @parser.to_s
        end

        
        

        def to_css
          if @parser.sorts.flatten.include? @parser.orders[0][0]
            "sorted #{@parser.sorts.assoc(@parser.orders[0][0]).last}"
          else
            "sorted"
          end
        end
      end

      def link_to_sorted(name, order, options = {})
        sorter          = Sorted.new(order, ((request.get? && !params.nil?) ? params.dup : nil))
        options[:class] = [options[:class], sorter.to_css].join(' ').strip
        link_to(name.to_s, sorter.params, options)
      end
    end
  end
end
