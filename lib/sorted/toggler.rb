module Sorted
  class Toggler
    def initialize(orders, sorts)
      @array = []
      @sorts      = sorts
      @orders     = orders
      @sort_keys  = sorts.transpose.first
      @order_keys = orders.transpose.first
      toggle_sorts unless @sort_keys.nil?
      add_remaining_orders
      add_remaining_sorts
    end

    def to_a
      @array
    end
    
    def toggle_sorts
      if @order_keys == @sort_keys.take(@order_keys.size)
        @order_keys.select do |order|
          @sort_keys.include?(order)
        end.each do |order|
          @array << [order, (case @sorts.assoc(order).last; when "asc"; "desc"; when "desc"; "asc" end)]
        end
      else
        @order_keys.select do |order|
          @sort_keys.include?(order)
        end.each do |order|
          @array << [order, @sorts.assoc(order).last]
        end
      end
      @sort_keys.select do |sort|
        @order_keys.include?(sort) && !@array.flatten.include?(sort)
      end.each do |sort|
        @array << [sort, @sorts.assoc(sort).last]
      end
    end

    def add_remaining_orders
      @orders.select do |order|
        !@array.flatten.include?(order[0])
      end.each do |order|
        @array << order
      end
    end

    def add_remaining_sorts
      @sorts.select do |sort|
        !@array.flatten.include?(sort[0])
      end.each do |sort|
        @array << sort
      end
    end
  end
end
