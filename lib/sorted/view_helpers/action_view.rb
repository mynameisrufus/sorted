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
        options[:class] = [options[:class], sorter.to_css].join(' ').strip
        link_to(name.to_s, sorter.params, options)
      end
    end
  end
end
