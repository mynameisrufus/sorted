module Sorted
  class Sorter
    def initialize(*args)
      parse_order(args[0])
      unless args[1].nil?
        @params = args[1]
        unless @params[:sort].nil?
          parse_sort(@params[:sort])
        end
      end
      self
    end
    
    def parse_sort(sort)
      sort.split(/!/).each do |s|
        if ps = parse_query(s)
          sort_queue << ps
        end 
      end
    end

    def parse_order(order)
      order.to_s.split(/,/).each do |o|
        if po = parse_sql(o)
          order_queue << po
        end
      end
    end
    
    def parse_query(sort)
      if m = sort.match(/(\w+)_(asc|desc)/)
        [m[1],m[2]]
      end
    end

    def parse_sql(sql)
      if m = sql.match(/(([a-zA-Z._]+)\s([asc|ASC|desc|DESC]+)|[a-zA-Z._]+)/)
        [(m[2].nil? ? m[1] : m[2]),(m[3].nil? ? "asc" : m[3].downcase)]
      end
    end

    def toggle
      @_array = []
      order_queue.select do |os|
        sort_queue.flatten.include?(os[0])
      end.each do |os|
        @_array << [os[0], (case sort_queue.assoc(os[0])[1]; when "asc"; "desc"; when "desc"; "asc" end)]
      end
      order_queue.select do |o|
        !@_array.flatten.include?(o[0])
      end.each do |o|
        @_array << [o[0], o[1]]
      end
      sort_queue.select do |s|
        !@_array.flatten.include?(s[0])
      end.each do |s|
        @_array << [s[0], s[1]]
      end
      self
    end

    def un_toggle
      @_array = default
      self
    end

    def to_hash
      _array.inject({}){|h,a| h.merge(Hash[a[0],a[1]]) }
    end
    
    def to_sql
      _array.map{|a| "#{a[0]} #{a[1].upcase}"}.join(', ')
    end

    def to_s
      _array.map{|a| a.join('_')}.join('!')
    end

    def css_class
      "sorted-#{_array[0][1]}"
    end

    def params
      @params ||= {}
      @params[:sort] = to_s unless _array.empty?
      @params
    end

    def order_queue
      @order_queue ||= []
    end

    def sort_queue
      @sort_queue ||= []
    end
    
    private
    def default
      _default = sort_queue.dup
      order_queue.each do |o|
        unless _default.flatten.include?(o[0])
          _default << [o[0], o[1]]
        end
      end
      _default
    end
    
    def _array
      @_array ||= default
    end
  end
end

if defined?(::Rails::Railtie)
  require 'sorted/railtie'
end
