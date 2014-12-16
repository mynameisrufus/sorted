require 'sorted/toggler'

module Sorted
  ##
  # Takes a sort query string and an SQL order string and parses the
  #
  # values to produce key value pairs.
  #
  # Example:
  #  Sorted::Parser.new('phone_desc', 'name ASC').to_s #-> "phone_desc!name_asc"

  Parser = Struct.new(:sort, :order) do
    def sorts
      URIQuery.parse(sort).to_a
    end

    def orders
      SQLQuery.parse(order).to_a
    end

    def to_hash
      Set.new(set).to_hash
    end

    def to_sql(quote_proc = ->(f) { f })
      SQLQuery.encode(set, quote_proc)
    end

    def to_s
      URIQuery.encode(set)
    end

    def to_a
      set
    end

    def toggle
      @set = Toggler.new(sorts, orders).to_a
      self
    end

    def reset
      @set = default(sorts)
      self
    end

    private

    def set
      @set ||= default(sorts)
    end

    def default(sort_set)
      orders.each do |o|
        sort_set << o unless sort_set.flatten.include?(o[0])
      end
      sort_set
    end
  end
end
