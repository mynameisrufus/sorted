module Sorted
  Set = Struct.new(:set) do
    def each(&block)
      set.each(&block)
    end

    def direction_intersect(other)
      memo = []
      each.with_index do |a, i|
        b = other.at(i)
        next unless b
        memo << (b.first == a.first ? [a.first, flip_direction(a.last)] : a)
      end
      self.class.new(memo)
    end

    def -(other)
      memo = []
      each do |a|
        b = other.assoc(a.first)
        next if b
        memo << a
      end
      self.class.new(memo)
    end

    def +(other)
      self.class.new(set + other.set)
    end

    def flip_direction(direction)
      case direction
      when 'asc' then 'desc'
      when 'desc'then  'asc'
      end
    end

    def assoc(obj)
      set.assoc(obj)
    end

    def at(i)
      set.at(i)
    end
  end

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
      (@sorts.direction_intersect(@orders) + (@sorts - @orders) + (@orders - @sorts)).set
    end
  end
end
