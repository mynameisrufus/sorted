module Sorted
  class Set
    include Enumerable
    include Comparable

    def initialize(ary = [])
      @ary = ary
    end

    ##
    # Calls the given block once for each element in self, passing that element
    # as a parameter.
    #
    # An Enumerator is returned if no block is given.

    def each
      return to_enum(:each) unless block_given?
      @ary.each { |item| yield item }
    end

    ##
    # Returns the keys form the array pairs.
    #
    #   set = Sorted::Set.new([["email", "desc"], ["name", "desc"]])
    #   set.keys #=> ["email", "name"]

    def keys
      @ary.transpose.first || []
    end

    ##
    # Returns a new array containing elements common to the two arrays,
    # excluding any duplicates.
    #
    # Any matching keys at matching indexes with the same order will have the
    # order reversed.
    #
    #   a = Sorted::Set.new([['email', 'asc'], ['name', 'asc']])
    #   b = Sorted::Set.new([['email', 'asc'], ['phone', 'asc']])
    #   s = a.direction_intersect(b)
    #   s.to_a #=> [['email', 'desc'], ['phone', 'asc'], ['name', 'asc']]

    def direction_intersect(other_set)
      self.class.new.tap do |memo|
        unless other_set.keys.empty?
          a(memo, other_set)
          b(memo, other_set)
        end
        c(memo)
        d(memo, other_set)
      end
    end

    ##
    # Array Difference - Returns a new set that is a copy of the original set,
    # removing any items that also appear in +other_set+. The order is preserved
    # from the original set.
    #
    #   set = Sorted::Set.new(['email', 'desc'])
    #   other_set = Sorted::Set.new(['phone', 'asc'])
    #   set - other_set #=> #<Sorted::Set:0x007fafde1ead80>

    def -(other_set)
      self.class.new.tap do |memo|
        each do |a|
          b = other_set.assoc(a.first)
          next if b
          memo << a
        end
      end
    end

    ##
    # Concatenation - Returns a new set built by concatenating the two sets
    # together to produce a third set.
    #
    #   set = Sorted::Set.new(['email', 'desc'])
    #   other_set = Sorted::Set.new(['phone', 'asc'])
    #   set + other_set #=> #<Sorted::Set:0x007fafde1ead80>

    def +(other_set)
      self.class.new(@ary + other_set.to_a)
    end

    ##
    # Append - Pushes the given order array on to the end of this set. This
    # expression returns the set itself, so several appends may be chained
    # together.
    #
    #   set = Sorted::Set.new(['name', 'asc'])
    #   set << ['email', 'desc'] << ['phone', 'asc']
    #   set.to_a #=> [['name', 'asc'], ['email', 'desc'], ['phone', 'asc']]

    def <<(ary)
      @ary << ary
      self
    end

    ##
    # Returns a new set containing all elements of self for which the given
    # block returns a true value.
    #
    # If no block is given, an Enumerator is returned instead.

    def select
      return to_enum(:select) unless block_given?
      self.class.new(@ary.select { |item| yield item })
    end

    ##
    # Returns a new set containing the items in self for which the given block
    # is not true.
    #
    # If no block is given, an Enumerator is returned instead.

    def reject
      return to_enum(:reject) unless block_given?
      self.class.new(@ary.reject { |item| yield item })
    end

    ##
    # Comparison - Returns an integer (-1, 0, or +1) if this array is less than,
    # equal to, or greater than +other_set+.

    def <=>(other_set)
      @ary <=> other_set.to_a
    end

    ##
    # Returns a new set by removing duplicate values in self.
    #
    # If a block is given, it will use the return value of the block for comparison.

    def uniq
      return self.class.new(@ary.uniq) unless block_given?
      self.class.new(@ary.uniq { |item| yield item })
    end

    ##
    # Searches through an array whose elements are also arrays comparing +item+
    # with the first element of each contained array using +item+.==.
    #
    # Returns the first contained array that matches (that is, the first
    # associated array), or nil if no match is found.

    def assoc(item)
      @ary.assoc(item)
    end

    ##
    # Returns key, order array pair at index +index+

    def at(index)
      @ary.at(index)
    end

    ##
    # Returns the underlying array for the set object.
    #
    #   set = Sorted::Set.new(['name', 'asc'])
    #   set.to_a #=> [['name', 'asc']]

    def to_a
      @ary
    end

    ##
    # Returns the result of interpreting ary as an array of [key, value] pairs.
    #
    #   set = Sorted::Set.new([['email', 'asc']])
    #   set.to_h #=> { 'email' => 'asc' }

    def to_h
      @ary.inject({}) { |a, e| a.merge(Hash[e[0], e[1]]) }
    end

    ##
    # Returns the number of elements in self. May be zero.

    def length
      @ary.length
    end
    alias_method :size, :length

    private

    # If the order of keys match upto the size of the set then flip them
    def a(memo, other)
      if keys == other.keys.take(keys.size)
        keys.each do |order|
          if other.keys.include?(order)
            memo << [order, flip_direction(other.assoc(order).last)]
          end
        end
      else
        keys.each do |order|
          if other.keys.include?(order)
            memo << other.assoc(order)
          end
        end
      end
    end

    # Add items from other that are common and not already added
    def b(memo, other)
      other.keys.each do |sort|
        if keys.include?(sort) && !memo.keys.include?(sort)
          memo << other.assoc(sort)
        end
      end
    end

    # Add items not in memo
    def c(memo)
      each do |order|
        unless memo.keys.include?(order[0])
          memo << order
        end
      end
    end

    # Add items from other not in memo
    def d(memo, other)
      other.each do |sort|
        unless memo.keys.include?(sort[0])
          memo << sort
        end
      end
    end

    def flip_direction(direction)
      case direction
      when 'asc' then 'desc'
      when 'desc' then 'asc'
      end
    end
  end
end
