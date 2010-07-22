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
    end
    
    def parse_sort(sort)
      sort.split(/!/).each do |s|
        @sort_queue = sort_queue.merge(parse_query(s))
      end
    end

    def parse_order(order)
      order.to_s.split(/,/).each do |o|
        @order_queue = order_queue.merge(parse_sql(o))
      end
    end
    
    def toggle
      @_hash = {}
      order_queue.each do |os|
        if sort_queue.key?(os[0])
          @_hash = _hash.merge(os[0] => (case os[1]; when "asc"; "desc"; when "desc"; "asc" end))
        end
      end
      sort_queue.each do |s|
        unless _hash.key?(s[0])
          @_hash = _hash.merge(s[0] => s[1])
        end
      end
      order_queue.each do |o|
        unless _hash.key?(o[0])
          @_hash = _hash.merge(o[0] => o[1])
        end
      end
      self
    end

    def default
      _default = sort_queue
      order_queue.each do |o|
        unless _default.key?(o[0])
          _default = _default.merge(o[0] => o[1])
        end
      end
      _default
    end

    def parse_query(sort)
      sort.match(/(\w+)_(asc|desc)/) do |m|
        Hash[m[1],m[2]]
      end
    end

    def parse_sql(sql)
      sql.match(/(([a-zA-Z._]+)\s([asc|ASC|desc|DESC]+)|[a-zA-Z._]+)/) do |m|
        Hash[(m[2].nil? ? m[1] : m[2]),(m[3].nil? ? "asc" : m[3].downcase)]
      end
    end
    
    def to_hash
      _hash
    end
    
    def to_sql
      _hash.map{|a| "#{a[0]} #{a[1].upcase}"}.join(', ')
    end

    def to_s
      _hash.map{|a| a.join('_')}.join('!')
    end

    def css_class
      "sorted-#{_hash.first[1]}"
    end

    def params
      @params[:sort] = to_s
      @params
    end

    def order_queue
      @order_queue ||= {}
    end

    def sort_queue
      @sort_queue ||= {}
    end
    
    private
    def _hash
      @_hash ||= default
    end
  end
end

if defined?(::Rails::Railtie)
  require 'sorted/railtie'
end
