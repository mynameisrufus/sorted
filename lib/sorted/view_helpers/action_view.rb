require 'action_view'
require 'sorted'

module Sorted
  module ViewHelpers
    module ActionView
      def sorted(order)
        ::Sorted::Sorter.new(order, (request.get? && !params.nil?) ? params.dup : nil).toggle
      end

      def link_to_sorted(name, order, options = {})
        sorter          = sorted(order)
        name            = name.nil? ? "" : name.to_s
        options[:class] = options[:class].nil? ? sorter.to_css : "#{options[:class]} #{sorter.to_css}"
        link_to(name, sorter.params, options)
      end
    end
  end
end
