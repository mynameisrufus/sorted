module Sorted
  ##
  # Takes a parsed arrays of sorts and orders, it then will reorder the pairs
  # and flip the ascendance of the first sort pair.
  #
  # Example:
  #   sorts  = [['name', 'asc'], ['phone', 'desc']]
  #   orders = [['name', 'asc']]
  #   Sorted::Toggler.new(sorts, orders).to_a
  #
  #  TODO Remove this in 2.x, it's only here for backwards compatibility.

  class Toggler
    def initialize(sorts, orders)
      @sorts = Set.new(sorts)
      @orders = Set.new(orders)
    end

    def toggle
      (@sorts.direction_intersect(@orders) + (@sorts - @orders) + (@orders - @sorts)).uniq
    end

    def to_a
      toggle.to_a
    end
  end
end
