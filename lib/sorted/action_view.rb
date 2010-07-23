require 'action_view'
require 'sorted'

module Sorted
  module ActionView
    def sorted(order)
      ::Sorted::Sorter.new(order, (request.get? && !params.nil?) ? params.dup : nil).toggle
    end

    def link_to_sorted(name, order, options = {})
      sorter = sorted(order)
      unless options[:class].nil?
        options[:class] = "#{options[:class]} #{sorter.css_class}"
      else
        options.merge(:class => sorter.css_class)
      end
      link_to(name, sorter.params, options)
    end
  end
end
