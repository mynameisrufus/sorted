module Sorted
  class Sorter
    def initialize(order, params = nil)
      if order.is_a?(String) || order.is_a?(Symbol)
        parse_order(order)
      end
      if params.is_a?(Hash)
        @params = params
        if @params[:sort].is_a?(String) 
          parse_sort @params[:sort]
        end
      end
    end
    
    def parse_sort(sort_string)
      sort_string.split(/!/).each do |sort|
        if parsed = parse_query(sort)
          sorts << parsed
        end 
      end
    end

    def parse_order(order_string_or_symbol)
      order_string_or_symbol.to_s.split(/,/).each do |order|
        if parsed = parse_sql(order)
          orders << parsed
        end
      end
    end
    
    def parse_query(sort)
      if m = sort.match(/([a-zA-Z0-9._]+)_(asc|desc)$/)
        [m[1],m[2]]
      end
    end

    def parse_sql(order)
      if m = order.match(/(([a-zA-Z._:]+)\s([asc|ASC|desc|DESC]+)|[a-zA-Z._:]+)/)
        [(m[2].nil? ? m[1] : m[2]),(m[3].nil? ? "asc" : m[3].downcase)]
      end
    end

    def toggle
      @array = Toggler.new(orders, sorts).to_a
      self
    end

    def reset
      @array = default
      self
    end

    def to_hash
      array.inject({}){|h,a| h.merge(Hash[a[0],a[1]])}
    end
    
    def to_sql
      array.map{|a| "#{a[0]} #{a[1].upcase}"}.join(', ')
    end

    def to_s
      array.map{|a| a.join('_')}.join('!')
    end

    def to_a
      array
    end
    
    def to_css
      if sorts.flatten.include?(orders[0][0])
        "sorted #{sorts.assoc(orders[0][0]).last}"
      else
        "sorted"
      end
    end

    def params
      @params ||= {}
      @params[:sort] = to_s
      @params
    end

    def orders
      @orders ||= []
    end

    def sorts
      @sorts ||= []
    end
    
    private
    def default
      sorts_new = sorts.dup
      orders.each do |order|
          sorts_new << order unless sorts_new.flatten.include?(order[0])
      end
      sorts_new
    end
    
    def array
      @array ||= default
    end
  end
end
