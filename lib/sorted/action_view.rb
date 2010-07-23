require 'action_view'
require 'sorted'

module Sorted
  module ActionView
    def sorted(order)
      ::Sorted::Sorter.new(order, (request.get? && !params.nil?) ? params.dup : nil).toggle
    end

    def link_to_sorted(name, order, options = {})
      sorter = sorted(order)
      options[:class] = options[:class].nil? ? sorter.css_class : "#{options[:class]} #{sorter.css_class}"
      link_to(name, sorter.params, options)
    end
  end
end
