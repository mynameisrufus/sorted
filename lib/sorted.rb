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
      if m = sort.match(/([a-zA-Z0-9._]+)_(asc|desc)$/)
        [m[1],m[2]]
      end
    end

    def parse_sql(sql)
      if m = sql.match(/(([a-zA-Z._:]+)\s([asc|ASC|desc|DESC]+)|[a-zA-Z._:]+)/)
        [(m[2].nil? ? m[1] : m[2]),(m[3].nil? ? "asc" : m[3].downcase)]
      end
    end
    
    def toggle
      @_array = []
      sorts  = sort_queue.transpose.first
      orders = order_queue.transpose.first
      unless sorts.nil?
        if orders == sorts.take(orders.size)
          orders.select do |order|
            sorts.include?(order)
          end.each do |order|
            @_array << [order, (case sort_queue.assoc(order).last; when "asc"; "desc"; when "desc"; "asc" end)]
          end
        else
          orders.select do |order|
            sorts.include?(order)
          end.each do |order|
            @_array << [order, sort_queue.assoc(order).last]
          end
        end
        sorts.select do |sort|
          orders.include?(sort) && !@_array.flatten.include?(sort)
        end.each do |sort|
          @_array << [sort, sort_queue.assoc(sort).last]
        end
      end
      order_queue.select do |order|
        !@_array.flatten.include?(order[0])
      end.each do |order|
        @_array << order
      end
      sort_queue.select do |sort|
        !@_array.flatten.include?(sort[0])
      end.each do |sort|
        @_array << sort
      end
      self
    end

    def reset
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

    def to_a
      _array
    end
    
    def to_css
      if sort_queue.flatten.include?(order_queue.first.first)
        "sorted #{sort_queue.assoc(order_queue.first.first).last}"
      else
        "sorted"
      end
    end

    def params
      @params ||= {}
      @params[:sort] = to_s
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
      sq = sort_queue.dup
      order_queue.each do |o|
          sq << o unless sq.flatten.include?(o[0])
      end
      sq
    end
    
    def _array
      @_array ||= default
    end
  end
end

if defined?(::Rails::Railtie)
  require 'sorted/railtie'
end
