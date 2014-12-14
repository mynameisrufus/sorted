require 'sorted/toggler'

module Sorted
  module Parse
    attr_reader :raw

    def initialize(raw)
      @raw = raw
    end

    def split(delim, &block)
      return [] if raw.nil?
      raw.to_s.split(delim).inject([], &block)
    end

    private :split
  end

  class SortParser
    include Parse

    REGEXP = /([a-zA-Z0-9._]+)_(asc|desc)$/

    def value
      split(/!/) do |set, part|
        m = part.match(REGEXP)
        return set unless m
        set << [m[1], m[2].downcase]
      end
    end
  end

  class OrderParser
    include Parse

    REGEXP = /(([a-z0-9._]+)\s([asc|desc]+)|[a-z0-9._]+)/i

    def value
      split(/,/) do |set, part|
        m = part.match(REGEXP)
        return set unless m
        set << [(m[2].nil? ? m[1] : m[2]), (m[3].nil? ? "asc" : m[3].downcase)]
      end
    end
  end

  SQLSerializer = Struct.new(:set, :quote_proc) do
    def value
      set.map { |a| "#{column(a[0])} #{a[1].upcase}" }.join(', ')
    end

    def column(parts)
      parts.split('.').map{ |frag| quote_proc.call(frag) }.join('.')
    end

    private :column
  end

  ##
  # Takes a sort query string and an SQL order string and parses the
  #
  # values to produce key value pairs.
  #
  # Example:
  #  Sorted::Parser.new('phone_desc', 'name ASC').to_s #-> "phone_desc!name_asc"

  Parser = Struct.new(:sort, :order) do
    def sorts
      SortParser.new(sort).value
    end

    def orders
      OrderParser.new(order).value
    end

    def to_hash
      set.inject({}) { |h, a| h.merge(Hash[a[0], a[1]]) }
    end

    def to_sql(quote_proc = ->(frag) { frag })
      SQLSerializer.new(set, quote_proc).value
    end

    def to_s
      set.map { |a| a.join('_') }.join('!')
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
