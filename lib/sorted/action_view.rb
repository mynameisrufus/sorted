require 'action_view'

module Sorted
  module ActionView
    def sorted(attribute)
      Sorter.new(attribute, (request.get? && !params.nil? ? params.dup : nil))
    end

    def link_to_sorted(name, attribute, options = {})
      sorted_object = sorted(name)
      unless options[:class].nil?
        options[:class] = "#{options[:class]} #{sorted_css_class}"
      else
        options.merge(:class => sorted_css_class)
      end
      link_to(name, sorted_object.params, options)
    end
    
    class Sorter
      def initialize(*args)
        raise "#{self.class} needs an attribute to sort with" if args[0].nil?
        @attribute = args[0].to_s
        @params    = args[1]
        unless @params.nil? || @params[:order].nil?
          @order = @params[:order]
        end
        to_hash
      end

      def params
        @params.nil? ? Hash[:order, to_s] : @params.merge(:order => to_s)
      end

      def current_order
        @current_order ||= "asc"
      end
       
      def to_hash
        @re_ordered ||= re_order
      end

      def other_attributes
        @other ||= {}
      end

      def to_s
        to_hash.map{ |attribute| attribute.join('_') }.join('!')
      end

      def css_class
        "sorted-#{current_order}"
      end
      
      private
      def re_order
        unless @order.nil?
          @order.split(/!/).each do |o|
            o.match(/(\w+)_(asc|desc)/) do |m|
              unless m[1].nil? || m[2].nil?
                if m[1] == @attribute
                  @current_order = direction_reverse(m[2])
                else
                  @other = other_attributes.merge(m[1] => m[2])
                end
              end
            end
          end
        end
        Hash[@attribute, current_order].merge(other_attributes).symbolize_keys
      end

      def direction_reverse(direction)
        case direction
        when "asc"
          "desc"
        when "desc"
          "asc"
        else
          "asc"
        end
      end
    end
  end
end
