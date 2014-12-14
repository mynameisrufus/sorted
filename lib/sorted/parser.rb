require 'sorted/toggler'

module Sorted
  # Takes a sort query string and an SQL order string and parses the
  # values to produce key value pairs.
  #
  # Example:
  #  Sorted::Parser.new('phone_desc', 'name ASC').to_s #-> "phone_desc!name_asc"
  #
  module Parse
    attr_reader :raw

    def initialize(raw)
      @raw = raw
    end

    def split(delim, &block)
      return [] if raw.nil?
      raw.to_s.split(delim).inject([], &block)
    end
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

  class Parser
    attr_reader :sorts, :orders

    def initialize(sort, order = nil)
      @sorts  = SortParser.new(sort).value
      @orders = OrderParser.new(order).value
    end

    def to_hash
      array.inject({}){|h,a| h.merge(Hash[a[0],a[1]])}
    end

    def to_sql(quoter = ->(frag) { frag })
      array.map do |a|
        column = a[0].split('.').map{ |frag| quoter.call(frag) }.join('.')
        "#{column} #{a[1].upcase}"
      end.join(', ')
    end

    def to_s
      array.map{|a| a.join('_') }.join('!')
    end

    def to_a
      array
    end

    def toggle
      @array = Toggler.new(sorts, orders).to_a
      self
    end

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
