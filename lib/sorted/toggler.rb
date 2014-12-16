module Sorted
  ##
  # Takes a parsed arrays of sorts and orders, it then will reorder the pairs
  # and flip the assendance of the first sort pair.
  #
  # Example:
  #   sorts  = [['name', 'asc'], ['phone', 'desc']]
  #   orders = [['name', 'asc']]
  #   Sorted::Toggler.new(sorts, orders).to_a

  class Toggler
    def initialize(sorts, orders)
      @sorts = Set.new(sorts)
      @orders = Set.new(orders)
    end

    def to_a
      (@sorts.direction_intersect(@orders) + (@sorts - @orders) + (@orders - @sorts)).to_a
    end
  end
end
