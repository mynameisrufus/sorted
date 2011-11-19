module Sorted
  # call from a model with a defaut order:
  #
  #  Sorted::Parser.new(sort, order)
  #  Sorted::Parser.new('name_asc!phone_desc', 'name ASC')
  class Parser
    attr_reader :sort, :order, :sorts, :orders

    # Regex to make sure we only get valid names and not injected code.
    SORTED_QUERY_REGEX  = /([a-zA-Z0-9._]+)_(asc|desc)$/
    SQL_REGEX           = /(([a-zA-Z._0-9]*)\s([asc|ASC|desc|DESC]+)|[a-zA-Z._0-9]*)/

    def initialize(sort, order = nil)
      @sort   = sort
      @order  = order
      @sorts  = parse_sort
      @orders = parse_order
    end

    def parse_sort
      sort.to_s.split(/!/).map do |sort_string|
        if m = sort_string.match(SORTED_QUERY_REGEX)
          [m[1], m[2]]
        end
      end.compact
    end

    def parse_order
      order.to_s.split(/,/).map do |order_string|
        if m = order_string.match(SQL_REGEX)
          [m[2], (m[3].nil? ? "asc" : m[3].downcase)]
        end
      end.compact
    end
   
    def to_hash
      array.inject({}){|h,a| h.merge(Hash[a[0],a[1]])}
    end
    
    def to_sql
      array.map{|a| "#{a[0]} #{a[1].upcase}" }.join(', ')
    end

    def to_s
      array.map{|a| a.join('_') }.join('!')
    end

    def to_a
      array
    end
    
    # Toggle the the sort options.
    #
    # For example if the sort string is:
    #
    #   'name_asc'
    #
    # it will become:
    #
    #   'name_desc'
    #
    def toggle
      @array = Toggler.new(orders, sorts).to_a
      self
    end
    
    # Removes the toggle from the sort options
    def reset
      @array = default
      self
    end

    private

    def array
      @array ||= default
    end

    def default
      sorts_new = sorts.dup
      orders.each do |o|
        sorts_new << o unless sorts_new.flatten.include?(o[0])
      end
      sorts_new
    end
  end
end
