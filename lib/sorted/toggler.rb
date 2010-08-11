module Sorted
  class Toggler
    class << self
      def toggle(order_queue, sort_queue)
        @@array = []
        sorts  = sort_queue.transpose.first
        orders = order_queue.transpose.first
        unless sorts.nil?
          if orders == sorts.take(orders.size)
            orders.select do |order|
              sorts.include?(order)
            end.each do |order|
              @@array << [order, (case sort_queue.assoc(order).last; when "asc"; "desc"; when "desc"; "asc" end)]
            end
          else
            orders.select do |order|
              sorts.include?(order)
            end.each do |order|
              @@array << [order, sort_queue.assoc(order).last]
            end
          end
          sorts.select do |sort|
            orders.include?(sort) && !@@array.flatten.include?(sort)
          end.each do |sort|
            @@array << [sort, sort_queue.assoc(sort).last]
          end
        end
        order_queue.select do |order|
          !@@array.flatten.include?(order[0])
        end.each do |order|
          @@array << order
        end
        sort_queue.select do |sort|
          !@@array.flatten.include?(sort[0])
        end.each do |sort|
          @@array << sort
        end
        @@array
      end
    end
  end
end
