require 'action_view'
require 'sorted'

module Sorted
  module ViewHelpers
    module ActionView
      class SortedViewHelper
        attr_reader :params

        def initialize(order, params = {})
          sort = params.delete :sort
          @params = params
          @parser = ::Sorted::Parser.new(sort, order).toggle
          @params[:sort] = @parser.to_s
        end

        def css
          if @parser.sorts.flatten.include? @parser.orders[0][0]
            "sorted #{@parser.sorts.assoc(@parser.orders[0][0]).last}"
          else
            "sorted"
          end
        end
      end

      # Creates a link tag of the given +name+ and +attribute+ creating
      # a url using a set of +options+.
      #
      # ==== Examples
      #
      # Basic usage
      #
      #   link_to_sorted "Email", :email
      #   # => <a href="/profiles?sort=email_asc" class="desc">Email</a>
      #
      # Or use a block
      #
      #   link_to_sorted :email do
      #     <strong>Sort by email</strong> -- <span></span>
      #   end
      #   # => <a href="/profiles?sort=email_asc" class="desc"><strong>Sort by email</strong> -- <span></span></a>
      #
      def link_to_sorted(*args, &block)
        if block_given?
          order        = args[0]
          options      = args[1] || {}
          html_options = args[2] || {}
        else
          block        = proc { args[0].to_s }
          order        = args[1]
          options      = args[2] || {}
          html_options = args[3] || {}
        end

        sorter          = SortedViewHelper.new(order, ((request.get? && !params.nil?) ? params.dup : {}))
        options[:class] = [options[:class], sorter.css].join(' ').strip
        link_to(sorter.params, options, html_options, &block)
      end

      # Convenience method for quickly spitting out a sorting menu.
      #
      # ==== Examples
      #
      # Basic usage
      #
      #   sort_by :first_name, :last_name
      #
      # To provide a string to use instead of a column name, pass an array composed
      # of your label string and the column name (symbol):
      #
      #   sortable_by :author_name, :title, ["Date of Publication", :published_at]
      #
      def sortable_by(*columns)
        links = content_tag :span, "Sort by: "
        columns.each do |c|
          if c.is_a? Array
            links += link_to_sorted(c[0],c[1].to_sym)
          else
            links += link_to_sorted(c.to_s.titleize, c.to_sym)
          end
        end
        content_tag :div, links, :class => 'sortable'
      end
    end
  end
end
